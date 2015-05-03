class ReportSerializer < ActiveModel::Serializer
  attributes :questions, :answers, :users, :answers_total, :questions_total, :users_total, :created_at, :updated_at
end
