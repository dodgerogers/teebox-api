class UserSerializer < ActiveModel::Serializer
  attributes :id, :username, :reputation, :rank, :created_at, :updated_at, :preferences
end