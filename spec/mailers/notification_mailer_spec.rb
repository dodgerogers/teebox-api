require "spec_helper"

describe NotificationMailer do
  before(:each) do
    ActionMailer::Base.perform_deliveries = true
    ActionMailer::Base.deliveries = []
    @user1 = create(:user, username: "dodgerogers")
    @question = create(:question, user_id: @user1.id)
  end
  
  after(:each) do
    ActionMailer::Base.deliveries.clear
    ActionMailer::Base.perform_deliveries = false
  end
  
  describe "activity_email" do
    before(:each) do
      @user2 = create(:user)
      @answer = create(:answer, user: @user2, question_id: @question.id, body: "try changing your face angle by #{@number} degrees")
      # Need all attributes of activity so render_activity uses the correct template_path
      @activity = create(:activity, key: "answer.create", trackable_id: @answer.id, trackable_type: "Answer", owner_id: @user2.id, owner_type: "User", recipient_id: @user1.id, recipient_type: "User", trackable_type: "Answer", read: false)
      NotificationMailer.any_instance.unstub(:activity_email)
      NotificationMailer.activity_email(@activity).deliver_now
    end
    
    it "should send the email" do
      ActionMailer::Base.deliveries.count.should eq(1)
    end
    
    it "renders the recipient email" do
      ActionMailer::Base.deliveries.first.to.should eq [@user1.email]
    end
    
    it "sets the correct subject line" do
      ActionMailer::Base.deliveries.first.subject.should eq "Notification from Teebox"
    end
    
    it "sends from the correct email address" do
      ActionMailer::Base.deliveries.first.from.should eq [CONFIG[:email_username]]
    end
  end
  
  describe "new_question_email" do
    before(:each) do
      NotificationMailer.any_instance.unstub(:new_question_email)
      NotificationMailer.new_question_email(@question).deliver_now
    end
    
    it "should send the email" do
      ActionMailer::Base.deliveries.count.should eq(1)
    end
    
    it "renders the recipient email" do
      ActionMailer::Base.deliveries.first.to.should eq [@user1.email]
    end
    
    it "sets the correct subject line" do
      ActionMailer::Base.deliveries.first.subject.should eq "New question: #{@question.title}"
    end
    
    it "sends from the correct email address" do
      ActionMailer::Base.deliveries.first.from.should eq [CONFIG[:email_username]]
    end
  end
end