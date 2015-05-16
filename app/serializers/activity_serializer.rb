class ActivitySerializer < ActiveModel::Serializer
  attributes :id, :recipient_id, :owner_id, :recipient_type, :owner_type, :read, :html
end
