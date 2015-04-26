class Vote < ActiveRecord::Base
  
  #attr_accessible :value, :votable_id, :votable_type, :points
  belongs_to :votable, polymorphic: true
  belongs_to :user
  has_one :point, as: :pointable, dependent: :destroy
  
  validates_inclusion_of :value, in: [1, -1]
  validates_presence_of :user_id, :value, :votable_id, :votable_type, :points
  validates_uniqueness_of :value, scope: [:votable_id, :user_id]
  validate :ensure_not_author
  
  #default_scope { includes(:votable) }
  
  before_validation :create_points
  after_create :update_count
  
  def ensure_not_author 
    if self.votable.try(:user_id) == self.user_id
      errors.add(:base, "You can't vote on your own content.")
    end
  end
  
  def create_points
    self.points = (self.value == 1 ? 5 : -5)
  end
  
  def update_count
    self.votable.update_attributes(votes_count: self.sum_points("value"))
  end
  
  def sum_points(column)
    self.votable.votes.sum(column)
  end
end