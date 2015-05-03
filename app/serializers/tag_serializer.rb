class TagSerializer < ActiveModel::Serializer
  attributes :name, :explanation, :updated_by, :user_id
end
