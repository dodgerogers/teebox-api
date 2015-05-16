require "spec_helper"

describe Api::AnswersController do
  include Devise::TestHelpers
  include AnswerHelper
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user1, question_id: @question.id)
    @request.env['HTTP_REFERER'] = "http://test.host/questions/"
    @params = { 
      user_token: @user1.authentication_token, 
      user_email: @user1.email, 
    }
  end
  
  subject { @answer }
  
  describe "GET show" do
    it "assigns a new answer as @answer" do
      get :show, @params.merge(id: @answer.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
    end
  end
  
  describe "POST create" do
    describe "with valid params" do
      it "returns 200 and answer" do
        question = create(:question, user: @user1)
        params = @params.merge(answer: { question_id: question.id, body: "Here is a valid answer..." })
        
        post :create, params
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include('answer')
      end
      
      it "calls point and notification creation methods when differing answer and question users" do
        question = create(:question, user: @user2)
        PointRepository.should_receive(:create)
        ActivityFactory.any_instance.should_receive(:generate)
        
        post :create, @params.merge(answer: { question_id: question.id, body: "Here is a valid answer..." })
        
        response.status.should eq 200
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        Answer.any_instance.stub(:save).and_return(false)
        
        post :create, @params.merge(answer: { question_id: @question.id, body: "Here is an invalid answer..." })
        
        response.status.should eq 422
      end
    end
  end
  
  describe "PUT update" do
    context "with valid params" do
      it "returns 200 when successful" do
        put :update, @params.merge(id: @answer.id, answer: { body: 'Valid answer content...'})

        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'answer'
      end
    end

    context "with invalid params" do
      it "returns 422" do
        Answer.any_instance.stub(:save).and_return(false)
        
        put :update, @params.merge(id: @answer.id, answer: { body: 'Invalid answer content...'})
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
    
    context "#correct" do
      it "success returns 200" do
        interactor = double()
        interactor.should_receive(:success?).and_return(true)
        interactor.should_receive(:answer).and_return(@answer)
        
        ToggleAnswerCorrect.should_receive(:call).and_return(interactor)
        put :correct, @params.merge(id: @answer)
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'answer'
      end
      
      it "failure returns 422" do
        interactor = double()
        interactor.should_receive(:success?).and_return(false)
        interactor.should_receive(:error).and_return('Error')
        
        ToggleAnswerCorrect.should_receive(:call).and_return(interactor)
        put :correct,  @params.merge(id: @answer)
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "Destroy Answer" do
    it "success returns 200" do
      delete :destroy, @params.merge(id: @answer)
      
      response.status.should eq 200
    end
    
    it "failure returns 422" do
      Answer.any_instance.stub(:destroy).and_return(false)
      delete :destroy, @params.merge(id: @answer)
      
      response.status.should eq 422
    end
  end
end