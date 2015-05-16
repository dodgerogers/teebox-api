class AnswerRepository < BaseRepository
  declare Answer
  
  NOT_FOUND = "Answer with ID: %s not found"
  
  def initialize(user)
    @user = user
  end
  
  def find_and_update(params)
    result = find_by_id params.slice :id
    return result unless result.success?
    
    answer = result.entity
    answer.assign_attributes params
    
    self.fail message: error_messages(answer) unless save(answer)
    self.entity = answer
    return self
  end
  
  def find_and_destroy(params)
    result = find_by params.slice :id
    
    return result unless result.success?
    self.fail message: error_messages(result.entity) unless destroy(result.entity)
    return self
  end
  
  private 
  
  def find_by_id(params)
    id = params.fetch :id
    answers = where answer, id: id
    
    self.fail message: NOT_FOUND % id unless answers.any?
    self.entity = answers.first
    return self
  end
end