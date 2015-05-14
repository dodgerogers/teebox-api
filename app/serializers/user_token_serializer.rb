class UserTokenSerializer < ActiveModel::Serializer
  attributes :id, :username, :authentication_token
end