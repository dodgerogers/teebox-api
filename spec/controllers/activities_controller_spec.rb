require "spec_helper"

describe Api::ActivitiesController do
  before(:each) do
    User.any_instance.stub(:create_welcome_notification).and_return(true)
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    @number = rand(1..9)
    @question = create(:question, user: @user1, title: "i can't hit my #{@number} iron", body: "im slicing the ball #{@number} yards")
    @answer = create(:answer, user: @user2, question_id: @question.id, body: "try changing your face angle by #{@number} degrees")
    @activity = create(:activity, trackable_id: @answer.id, recipient_id: @user1.id, recipient_type: "User", trackable_type: "Answer", read: false)
    @params = { user_token: @user1.authentication_token, user_email: @user1.email }
  end

  describe "GET index" do
    it "renders index template" do
      get :index, @params
      
      response.status.should eq 200
      data = JSON.parse response.body
      data["activities"].size.should eq 1
    end
  end
  
  describe "read" do
    describe "with valid params" do
      it "assigns the requested activity as @activity" do
        get :read, @params.merge!(id: @activity)
        
        response.status.should eq 200
        data = JSON.parse response.body
        data["id"].should eq @activity.id
      end
    end
      
    describe "with invalid params" do
      it "redirects to root" do
        Activity.any_instance.stub(:save).and_return(false)
        put :read, @params.merge!(id: @activity)
        
        @activity.reload
        response.status.should eq 422
      end
    end
  end
end