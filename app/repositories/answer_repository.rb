class AnswerRepository < BaseRepository
  
  def self.find_by(attributes)
    results = self.klass.where(attributes)
    return results.first, results.any?
  end
  
  private
  
  def self.klass
    Answer
  end
end