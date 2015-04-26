class Comment < ActiveRecord::Base
  
  #include PublicActivity::Common
  require 'obscenity/active_model'
  
  #attr_accessible :content, :votes_count, :parent_id, :commentable_id, :commentable_type, :points
  
  belongs_to :user
  belongs_to :commentable, polymorphic: true, counter_cache: true
  has_many :votes, as: :votable, dependent: :destroy
  has_one :point, as: :pointable, dependent: :destroy
  has_many :activities, as: :trackable, dependent: :destroy
  
  validates_presence_of :user_id, :content, :commentable_id, :commentable_type
  validates_length_of :content, minimum: 10,  maximum: 500
  validates :content, obscenity: true
  
  with_options if: "find_mentions.any?" do
    validate :mentions_limit
    after_create :display_mentions
  end
  
  default_scope { order("created_at") }
  
  def find_mentions
    @mentions ||= self.content.scan(/@([a-z0-9_]+)/i).flatten
  end
  
  def mentions_limit
    return unless errors.blank?
    if find_mentions.uniq.length != find_mentions.length
      errors.add(:content, "You can only mention someone once") 
    end
  end
  
  def display_mentions
    find_mentions.each do |u|
      user = User.where(username: u)[0]
      
      if user && self.user != user
        link_structure = "<a href='/users/#{user.id}-#{u}'>@#{u}</a>"
        self.content.gsub!(/#{Regexp.escape("@#{u}")}/, link_structure)
        unless user == self.commentable
          repo = ActivityRepository.new(self)
          repo.generate(:create, owner: self.user, recipient: user)
        end
      end
    end
    self.save!
  end
  
  def notification_message_format
    { 
      link: (self.commentable.respond_to?(:title) ? self.commentable.try(:title) : self.commentable.try(:body)), 
      text: 'commented on' 
    }
  end
end