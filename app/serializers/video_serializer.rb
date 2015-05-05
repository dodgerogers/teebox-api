class VideoSerializer < ActiveModel::Serializer
  attributes :id, :file, :screenshot, :job_id, :status, :name, :duration, :location, :user_id
end