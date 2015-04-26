class Article < ActiveRecord::Base
  #include PublicActivity::Common
  include Teebox::Searchable
  
  DRAFT = 'draft'
  SUBMITTED = 'submitted'
  APPROVED = 'approved'
  PUBLISHED = 'published'
  DISCARDED = 'discarded'
  
  DRAFT_ACTION = 'draft'
  SUBMIT_ACTION = 'submit'
  APPROVE_ACTION = 'approve'
  PUBLISH_ACTION = 'publish'
  DISCARD_ACTION = 'discard'
  
  TRANSITION_ERR_MSG = 'State has already been %s'
  
  VALID_STATES = [DRAFT, SUBMITTED, APPROVED, PUBLISHED, DISCARDED]
  
  DRAFT_MESSAGE = 'Revert to draft and remove from homepage'
  SUBMITTED_MESSAGE = 'Submit for review and approval'
  APPROVED_MESSAGE = 'Approve and then schedule for publishing'
  PUBLISHED_MESSAGE = 'Publish to display on the homepage'
  DISCARDED_MESSAGE = 'Discard article'
  
  #attr_accessible :title, :body, :state, :points, :votes_count, :comments_count, :impressions_count, :user_id, :cover_image, :published_at
  
  belongs_to :user
  
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_one :point, as: :pointable, dependent: :destroy
  has_many :impressions, as: :impressionable, dependent: :destroy
  
  validates_presence_of :title, :body, :user_id, :cover_image, :state
  validates_inclusion_of :state, in: VALID_STATES
  
  scope :state, lambda {|state| where(state: state) }
  scope :search_conditions, lambda { state(PUBLISHED).includes(:user) }
  
  searchable :title
  
  state_machine :state, initial: DRAFT do
    before_transition APPROVED => PUBLISHED do |article|
      article.published_at = Date.today
      article.updated_at = Date.today
    end
    
    before_transition PUBLISHED => DRAFT do |article|
      article.published_at = nil
    end
    
    event DRAFT_ACTION do
      transition (any - DRAFT) => DRAFT
    end
    
    event SUBMIT_ACTION do
      transition DRAFT => SUBMITTED
    end
    
    event APPROVE_ACTION do
      transition SUBMITTED => APPROVED
    end
    
    event PUBLISH_ACTION do
      transition APPROVED => PUBLISHED
    end
    
    event DISCARD_ACTION do
      transition (any - [PUBLISHED, DISCARDED]) => DISCARDED
    end
  end
  
  def to_param
    "#{id} - #{title}".parameterize
  end
  
  def notification_message_format
    { 
      link: self.title, 
      text: self.state
    }
  end
  
  def self.state_explanation
    {
       DRAFT_ACTION => DRAFT_MESSAGE,
       SUBMIT_ACTION => SUBMITTED_MESSAGE,
       APPROVE_ACTION => APPROVED_MESSAGE,
       PUBLISH_ACTION => PUBLISHED_MESSAGE,
       DISCARD_ACTION => DISCARDED_MESSAGE
    }
  end
end