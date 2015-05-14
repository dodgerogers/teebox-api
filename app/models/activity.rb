class Activity < ActiveRecord::Base
  
  #attr_accessible :read, :html
  belongs_to :trackable, polymorphic: true
  belongs_to :recipient, polymorphic: true
  belongs_to :owner, polymorphic: true
  
  after_commit :notify_recipient, on: :create

  # ==== Needs to be moved to the repo ==== #
  def self.latest_notifications(user)
    where(recipient_id: user.id).order("created_at DESC")
  end

  def self.unread_notifications(user)
    self.where(read: false, recipient_id: user.id).size
  end
  # ==== end ==== #
  
  # ==== to go in the read activity interactor ==== #
  def read_activity
    self.toggle(:read) if self.read == false
  end
  # === end ==== #
  
  def notify_recipient
    if self.recipient.notifications == "1" && self.trackable_type != "User"
      NotificationMailer.delay.activity_email(self)
    end
  end
end