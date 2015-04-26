class NotificationMailer < ActionMailer::Base
  # include PublicActivity::ViewHelpers
  #   helper ApplicationHelper
  #   helper ActivityHelper
  
  default from: CONFIG[:email_username]
  
  def new_question_email(question)
    @question = question
    @email = User.where(username: "dodgerogers")[0].email
    mail(to: @email, subject: "New question: #{@question.title}")
  end
  
  def activity_email(activity)
    @activity = activity
    mail(to: @activity.recipient.email, subject: "Notification from Teebox")
  end
end
