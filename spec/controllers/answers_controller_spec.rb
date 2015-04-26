require "spec_helper"

describe AnswersController do
  include Devise::TestHelpers
  include AnswerHelper
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user1.confirm!
    @user2.confirm!
    sign_in @user1
    sign_in @user2
    @question = create(:question, user: @user2)
    @answer = create(:answer, user: @user1, question_id: @question.id)
    @vote = attributes_for(:vote, votable_id: @answer.id, user_id: @user2, votable_type: "Answer", value: 1, points: 5)
    controller.stub!(:current_user).and_return(@user1)
    @request.env['HTTP_REFERER'] = "http://test.host/questions/"
  end
  
  subject { @answer }
  
  describe "GET show" do
    it "assigns a new answer as @answer" do
      get :show, question_id: @question.id, id: @answer
      assigns(:answer).should eq(@answer)
    end
    
    it "renders the show template" do
      get :show, question_id: @question.id, id: @answer
      response.should render_template :show
    end
  end
  
  
  describe "POST create" do
    describe "with valid params" do
      it "creates a new answer" do
        @question = create(:question, user: @user1)
        expect {
          post :create, answer: attributes_for(:answer, question_id: @question.id)
        }.to change(Answer, :count).by(1)
      end
      
      it "creates a new answer point" do
        @question = create(:question, user: @user1)
        expect {
          post :create, answer: attributes_for(:answer, question_id: @question.id)
        }.to change(Point, :count).by(1)
      end

      it "assigns a newly created answer as @answer" do
        @question = create(:question, user: @user1)
        post :create, answer: attributes_for(:answer, question_id: @question.id)
        assigns(:answer).should be_a(Answer)
        assigns(:answer).should be_persisted
      end
      
      it "calls point and notification creation methods when differing answer and question users" do
        @question = create(:question, user: @user2)
        
        PointRepository.should_receive(:create).and_return(create(:point))
        Activity.destroy_all
        ActivityRepository.any_instance.should_receive(:generate).and_return(create(:activity))
        
        post :create, answer: attributes_for(:answer, question_id: @question.id)
        
        Point.all.size.should eq 1
        Activity.all.size.should eq 1
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        # Trigger the behavior that occurs when invalid params are submitted
        Answer.any_instance.stub(:save).and_return(false)
        post :create, answer: attributes_for(:answer)
        assigns(:answer).should be_a_new(Answer)
      end
    end
  end
  
  describe "PUT update" do
    it "assigns the requested question as @answer" do
      @answer = create(:answer, body: "weaken your grip", question_id: @question.id)
      put :update, id: @answer, answer: attributes_for(:answer)
      assigns(:answer).should eq(@answer)
    end
    
    describe "with valid params" do
      it "updates the requested answer" do
        @answer = create(:answer, body: "weaken your grip", question_id: @question.id)
        put :update, id: @answer, answer: attributes_for(:answer, body: "close your stance")
        @answer.reload
        @answer.body.should eq("close your stance")
      end

      it "redirects to the post" do
        @answer = create(:answer, body: "weaken your grip", question_id: @question.id)
        put :update, id: @answer, answer: attributes_for(:answer, body: "close your stance")
        @answer.reload
        response.should redirect_to :back
      end
    end

    describe "with invalid params" do
      it "doesn not change @answer attributes" do
        @answer = create(:answer, body: "weaken your grip", question_id: @question.id)
        put :update, id: @answer, answer: attributes_for(:answer, body: ""), format: "js"
        @answer.reload
        @answer.body.should_not eq("")
      end
    end
    
    describe "#correct" do
      it "success redirects to question" do
        interactor = mock()
        interactor.should_receive(:success?).and_return(true)
        interactor.should_receive(:answer).and_return(@answer)
        
        ToggleAnswerCorrect.should_receive(:call).and_return(interactor)
        put :correct, id: @answer, answer: @answer
        
        @answer.reload
        response.should redirect_to @answer.question
        flash[:notice].should include('Success')
      end
      
      it "failure redirects to question with error" do
        interactor = mock()
        interactor.should_receive(:success?).and_return(false)
        interactor.should_receive(:error).and_return('Error')
        
        ToggleAnswerCorrect.should_receive(:call).and_return(interactor)
        put :correct, id: @answer, answer: @answer
        
        @answer.reload
        response.should redirect_to @answer.question
        flash[:notice].should include('Error')
      end
    end
  end
  
  describe "Destroy Answer" do
    it "destroys the requested answer" do
      @question = create(:question, user: @user1)
      @answer = create(:answer, user: @user2, question_id: @question.id)
      expect {
        delete :destroy, id: @answer
      }.to change(Answer, :count).by(-1)
    end
  end
end