class ToggleAnswerCorrect
  include Interactor
  
  STANDARD_ERR = 'ToggleAnswer: %s'
  NOT_FOUND = "Could not find answer with id: %s"
  INVALID_RELATION = 'A question could not be found for this answer'
  POINT_UPDATE_FAILED = 'Failed to update points'
  
  def call
    unless context[:id]
      context.fail!(error: sprintf(STANDARD_ERR, 'You must provide an id'))
    end
    
    answer, success = AnswerRepository.find_by(id: context[:id])
    
    if answer && success 
      raise ArgumentError, sprintf(STANDARD_ERR, INVALID_RELATION) unless answer.question
      
      ActiveRecord::Base.transaction do
        toggle_attributes(answer, answer.question)
      
        default_point_attributes = create_point_attributes(answer, answer.question)
        attrs = assign_point_attributes(answer)
        
        if attrs.present?
          default_point_attributes.deep_merge!(attrs)
      
          points_updated = PointRepository.mass_update(*default_point_attributes.values)
          fail_and_raise_rollback(POINT_UPDATE_FAILED) unless points_updated
        end
      end
      context.answer = answer
    else
      context.fail!(error: sprintf(STANDARD_ERR, NOT_FOUND))
    end
  end
  
  private
  
  def fail_and_raise_rollback(error)
    context.fail!(error: sprintf(STANDARD_ERR, error))
    raise ActiveRecord::Rollback
  end
  
  def toggle_attributes(*records)
    records.each do |record|
      record.correct = !record.correct
      unless record.save
        fail_and_raise_rollback(record.errors.full_messages.join(', '))
      end
    end
  end
  
  def create_point_attributes(*records)
    result = {}
    records.each do |record|
      klass = record.class.to_s.downcase
      result[klass.to_sym] = { entry: record, value: 0 }
    end
    return result
  end
  
  def assign_point_attributes(answer)
    if correct_and_author?(answer, true)
      { 
        answer: { 
          value: Answer::CORRECT_ANSWER 
        }, 
        question: { 
          value: Answer::QUESTION_MARKED_AS_CORRECT 
        } 
      }
    elsif correct_and_author?(answer, false)
      { 
        answer: { 
          value: Answer::REVERT 
        }, 
        question: { 
          value: Answer::REVERT 
        } 
      }
    end
  end
  
  def correct_and_author?(answer, boolean)
    answer.correct == boolean && answer.user != answer.question.user
  end
end