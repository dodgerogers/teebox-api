class CommentSerializer < ActiveModel::Serializer
  attributes :id, :content, :votes_count, :commentable_id, :commentable_type
  
end
