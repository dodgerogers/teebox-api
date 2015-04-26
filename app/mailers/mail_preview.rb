class MailPreview < MailView
  
  def notification
    user = User.last
    activity = Activity.last
    NotificationMailer.activity_email(activity)
  end
  
  def new_question
    question = Question.last
    NotificationMailer.new_question_email(question)
  end
  
  def welcome_email
    user = User.last
    Devise::Mailer.confirmation_instructions(user)
  end
  
  def reset_password
    user = User.last
    Devise::Mailer.reset_password_instructions(user)
  end
end