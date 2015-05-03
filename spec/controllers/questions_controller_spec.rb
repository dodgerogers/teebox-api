require 'spec_helper'

describe Api::QuestionsController do
  include Devise::TestHelpers
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user2.confirm!
    @user1.confirm!
    @question = create(:question, user: @user1)
    @params = { 
      user_token: @user1.authentication_token, 
      user_email: @user1.email, 
    }
  end

  describe "GET show" do
    it "returns 200" do
      ImpressionRepository.should_receive(:create).with(@question, request)
      
      get :show, @params.merge!(id: @question.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'question'
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'questions'
    end
  end
  
  describe "POST create" do
    describe "success" do
      it "returns 200 and question" do
        post :create, @params.merge(question: { title: 'Question title', body: 'question body content' })
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'question'
      end
    end

    describe "failure" do
      it "returns 422 and errors" do
        Question.any_instance.stub(:save).and_return(false)
        post :create, @params.merge(question: { title: 'Question title', body: 'question body content' })
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "new_question_email email" do
    before(:each) do
      NotificationMailer.any_instance.unstub(:new_question_email)
      ActionMailer::Base.deliveries = []
      ActionMailer::Base.perform_deliveries = true
      User.any_instance.stub(:send_on_create_confirmation_instructions).and_return(true)
      @user = create(:user, username: "dodgerogers")
    end
    
    after(:each) do
      NotificationMailer.any_instance.stub(:new_question_email)
      ActionMailer::Base.deliveries.clear
      ActionMailer::Base.perform_deliveries = false
    end
    
    it "successfully sends after create" do
      post :create, @params.merge(question: attributes_for(:question))
      
      response.status.should eq 200
      ActionMailer::Base.deliveries.count.should eq 1
    end
  end

  describe "PUT update" do
    context 'success' do
      it "returns 200 and question" do
        put :update, @params.merge(id: @question.id, question: {title: "Shanking now, great!"})
       
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'question'
      end
    end

    context "failure" do
      it "returns 422 and errors" do
        Question.any_instance.stub(:save).and_return(false)
        put :update, @params.merge(id: @question.id, question: {title: "Shanking now, great!"})
       
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end

  describe "DELETE destroy" do
    context 'success' do
      it "returns 200" do
        delete :destroy, @params.merge(id: @question.id)
      
        response.status.should eq 200
      end
    end
    
    context 'failure' do
      it 'returns 422 and errors' do
        Question.any_instance.stub(:destroy).and_return(false)
        
        delete :destroy, @params.merge(id: @question.id)
      
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
end
