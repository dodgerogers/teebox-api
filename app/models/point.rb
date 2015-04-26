class Point < ActiveRecord::Base
  
  after_create :user_reputation
  after_destroy :user_reputation
  after_update :user_reputation
  
  #attr_accessible :value, :pointable_id, :pointable_type
  belongs_to :user
  belongs_to :pointable, polymorphic: true

  def user_reputation
    self.user.update_attributes(reputation: self.user.points.sum("value"))
  end
  
  def self.find_points(user)
    user.points.where("value != 0").order("updated_at desc").includes(:pointable)
  end
end