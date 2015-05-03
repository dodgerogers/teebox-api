class Vote < ActiveRecord::Base
  
  VOTE_POSITIVE_VALUE = 1
  VOTE_NEGATIVE_VALUE = -1
  VALID_VALUES = [VOTE_POSITIVE_VALUE, VOTE_NEGATIVE_VALUE]
  
  POSITIVE_POINTS = 5
  NEGATIVE_POINTS = -5
  
  #attr_accessible :value, :votable_id, :votable_type, :points
  belongs_to :votable, polymorphic: true
  belongs_to :user
  has_one :point, as: :pointable, dependent: :destroy
  
  validates_inclusion_of :value, in: VALID_VALUES
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
    self.points = (self.value == VOTE_POSITIVE_VALUE ? POSITIVE_POINTS : NEGATIVE_POINTS)
  end
  
  def update_count
    self.votable.update_attributes(votes_count: self.sum_points("value"))
  end
  
  def sum_points(column)
    self.votable.votes.sum(column)
  end
end