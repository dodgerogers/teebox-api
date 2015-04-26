class Activity < ActiveRecord::Base
  
  #attr_accessible :read, :html
  belongs_to :trackable, polymorphic: true
  belongs_to :recipient, polymorphic: true
  belongs_to :owner, polymorphic: true
  
  after_commit :notify_recipient, on: :create

  def self.latest_notifications(user)
    where(recipient_id: user.id).order("created_at DESC")
  end

  def self.unread_notifications(user)
    self.where(read: false, recipient_id: user.id).size
  end
  
  def notify_recipient
    # If notifications is set to true send mail
    # also don't want to send en email for the welcome notification
    if self.recipient.notifications == "1" && self.trackable_type != "User"
      NotificationMailer.delay.activity_email(self)
    end
  end

  def read_activity
    self.toggle(:read) if self.read == false
  end
end