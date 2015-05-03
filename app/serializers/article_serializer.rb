class ArticleSerializer < ActiveModel::Serializer
  attributes :title, :body, :state, :votes_count, :comments_count, :impressions_count, :user_id, :cover_image, :published_at, :created_at, :updated_at
  
  has_many :comments
end
