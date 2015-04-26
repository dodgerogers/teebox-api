require "spec_helper"

describe Activity do
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @number = rand(1..9)
    @question = create(:question, user: @user1, title: "i can't hit my #{@number} iron", body: "im slicing the ball #{@number} yards")
    @answer = create(:answer, user: @user2, question_id: @question.id, body: "try changing your face angle by #{@number} degrees")
    @activity = create(:activity, trackable: @answer, recipient: @user1, owner: @user2)
  end
  
  subject { @activity }
  
  it { should respond_to(:owner_id) }
  it { should respond_to(:owner_type) }
  it { should respond_to(:key) }
  it { should respond_to(:parameters) }
  it { should respond_to(:recipient_id) }
  it { should respond_to(:recipient_type) }
  it { should respond_to(:read) }
  it { should respond_to(:trackable_id) }
  it { should respond_to(:trackable_type) }
  it { should belong_to(:trackable)}
  it { should belong_to(:owner)}
  
  describe "unread_notifications" do
    it "shows number of unread notifications" do
      #accounts for activity created when signing up a user
      Activity.unread_notifications(@user1).should eq(2)
    end
  end
  
  describe "latest_notifications" do
    it "shows number of new_activities" do
      #accounts for activity created when signing up a user
      activities = Activity.latest_notifications(@user1)
      activities.count.should eq 2
      activities.first.should eq @activity
    end
  end
end