class Question < ActiveRecord::Base
  include Teebox::Toggle
  include Teebox::Searchable
  require 'obscenity/active_model'
  
  #attr_accessible :title, :body, :youtube_url, :votes_count, :answers_count, :comments_count, :points, 
                  #:correct, :tag_tokens, :video_list, :videos_count
  #attr_reader :tag_tokens
  
  belongs_to :user
  
  has_many :videos, through: :playlists, counter_cache: true
  has_many :playlists, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy
  has_many :taggings, dependent: :destroy
  has_many :tags, through: :taggings
  has_one :point, as: :pointable, dependent: :destroy
  has_many :impressions, as: :impressionable, dependent: :destroy

  validates_presence_of :title, :body, :user_id
  validates_length_of :title, minimum: 10, maximum: 85
  validates_length_of :body, minimum: 10, maximum: 5000
  validate :tag_limit, :video_limit, :ensure_own_videos
  validates :body, obscenity: true
  validates :title, obscenity: true
  
  scope :unanswered, lambda { where(correct: false) }
  scope :popular, lambda { order("votes_count DESC") }
  scope :newest, lambda { order("created_at DESC") }
  scope :search_conditions, lambda { includes(:user, :videos) }
  
  searchable :title
  
  def to_param
    "#{id} - #{title}".parameterize
  end
  
  def video_list
    self.videos.map(&:id).join(",")
  end
  
  def video_list=(ids)
    self.videos = ids.split(",").map { |n| Video.find(n) }
  end
  
  def video_limit
    errors.add(:video_list, "Maximum of 3 videos") if self.videos.size > 3 if self.videos
  end
  
  def ensure_own_videos
    if self.videos.any?
      video_ids = self.videos.map(&:user_id)
      unless video_ids.count(self.user_id) == video_ids.size
        errors.add(:video_id, "You can only use your own videos")
      end
    end
  end
  
  def tag_tokens=(tokens)
    self.tag_ids = Tag.ids_from_tokens(tokens)
  end
  
  def self.tagged_with(name)
    Tag.find_by_name!(name).questions
  end
  
  def tag_limit
    errors.add(:tag_tokens, "Maximum of 5 Tags per Question") if self.tags.size > 5 if self.tags
  end
end