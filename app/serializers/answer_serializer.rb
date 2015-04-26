class AnswerSerializer < ActiveModel::Serializer
  attributes :id, :body, :question_id, :votes_count, :correct, :comments_count
  
  has_many :comments
end
