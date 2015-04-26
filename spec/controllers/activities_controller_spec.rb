require "spec_helper"

describe ActivitiesController do
  include Devise::TestHelpers
  include ActionView::Helpers::UrlHelper
  before(:each) do
    #negate the activity created upon signup
    User.any_instance.stub(:create_welcome_notification).and_return(true)
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    sign_in @user1
    sign_in @user2
    controller.stub!(:current_user).and_return(@user1)
    @number = rand(1..9)
    @question = create(:question, user: @user1, title: "i can't hit my #{@number} iron", body: "im slicing the ball #{@number} yards")
    @answer = create(:answer, user: @user2, question_id: @question.id, body: "try changing your face angle by #{@number} degrees")
    @activity = create(:activity, trackable_id: @answer.id, recipient_id: @user1.id, recipient_type: "User", trackable_type: "Answer", read: false)
  end

  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template :index
    end
  end
  
  describe "notifications" do
    it "render index partial" do
      get :notifications
      response.should render_template :index
    end
  end
  
  describe "read" do
    describe "with valid params" do
      it "assigns the requested activity as @activity" do
        get :read, id: @activity
        assigns(:activity).should eq(@activity)
      end

      it "toggles the read column" do
        get :read, id: @activity
        @activity.reload
        @activity.read.should eq true
      end

      it "redirects to the post" do
        get :read, id: @activity
        @activity.reload
        response.should redirect_to @activity.trackable
      end
      
    describe "with invalid params" do
      it "redirects to root" do
        Activity.any_instance.stub(:save).and_return(false)
        put :read, id: @activity
        @activity.reload
        response.should redirect_to root_path
        end
      end
    end
  end
end