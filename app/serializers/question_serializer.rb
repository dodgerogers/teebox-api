class QuestionSerializer < ActiveModel::Serializer
  attributes :id, :title, :body, :user_id, :votes_count, :answers_count, :comments_count, :correct, :video_list, :videos_count
  
  has_many :videos, through: :playlists
  has_many :answers
  has_many :comments
  has_many :tags, through: :taggings
  has_many :taggings
end
