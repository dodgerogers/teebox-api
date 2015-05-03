class UserSerializer < ActiveModel::Serializer
  attributes :email, :username, :reputation, :rank, :created_at, :updated_at, :preferences
end