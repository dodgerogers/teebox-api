class VoteSerializer < ActiveModel::Serializer
  attributes :value, :user_id, :votable_id, :votable_type, :points, :created_at, :updated_at
end