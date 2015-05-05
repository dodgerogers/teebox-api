class User < ActiveRecord::Base
  include Teebox::Searchable
  
  ADMIN = 'admin'
  TESTER = 'tester'
  STANDARD = 'standard'
  
  ROLES = [ADMIN, TESTER, STANDARD]
  
  devise :database_authenticatable, :registerable, :confirmable, :recoverable, :rememberable, :trackable, :validatable
             
  acts_as_token_authenticatable
  
  serializeable :preferences, { notifications: "1" }
  
  validates :username, presence: true, uniqueness: true, length: { maximum: 30 }

  has_many :questions, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :videos, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :tags
  has_many :points, dependent: :destroy
  has_many :activities, foreign_key: :recipient_id, dependent: :destroy

  before_save :ensure_authentication_token
  after_create :create_welcome_notification
  
  searchable :username
  
  def to_param
    "#{id} - #{username}".parameterize
  end
  
  def admin?
    self.role == ADMIN
  end
  
  def ensure_authentication_token
    if authentication_token.blank?
      self.authentication_token = generate_authentication_token
    end
  end
  
  # ==== Should override these 2 methods devise controller and call super then perform this. ==== #
  def create_welcome_notification
    repo = ActivityRepository.new(self)
    repo.generate(:create, recipient: self)
  end
  
  def send_on_create_confirmation_instructions
    Devise::Mailer.delay.confirmation_instructions(self)
  end
  # ==== end ==== #
  
  # TODO: Should be able to do this in one go
  def self.rank_by_reputation
    results = {}
    self.order("reputation desc").each do |user| 
       results[user.reputation] = self.where(reputation: user.reputation).map(&:id)
    end
    return results
  end
  
  def self.rank_users
    self.rank_by_reputation.each_with_index do |users, rank|
      self.where(id: users[1]).update_all(rank: rank + 1)
    end
  end
  
  def notification_message_format
    { 
      link: 'here', 
      text: 'Need a refresher on how it works? Click' 
    }
  end
  
  private 
  
  def generate_authentication_token
    loop do
      token = Devise.friendly_token
      break token unless User.where(authentication_token: token).first
    end
  end
end