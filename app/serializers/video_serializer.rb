class VideoSerializer < ActiveModel::Serializer
  attributes :file, :screenshot, :job_id, :status, :name, :duration, :location
  
  has_many :questions, through: :playlists
  has_many :playlists
end