require 'spec_helper'

describe QuestionsController do
  include Devise::TestHelpers
  include AnswerHelper
  before(:each) do
    @user1 = create(:user)
    @user2 = create(:user)
    @user2.confirm!
    @user1.confirm!
    sign_in @user1
    sign_in @user2
    @question = create(:question, user: @user1)
    controller.stub!(:current_user).and_return(@user1)
    @vote = attributes_for(:question_vote, votable_id: @question.id, user_id: @user2, votable_type: "Question", value: 1)
    @request.env['HTTP_REFERER'] = "/questions/#{@question}/"
  end

  describe "GET show" do
    it "assigns a new decorator as @decorator" do
      @decorator = @question
      get :show, id: @decorator
      assigns(:decorator).should eq(@decorator)
    end
    
    it "renders the show template" do
      get :show, id: @question
      response.should render_template :show
    end
    
    it "renders the show JSON template" do
      get :show, id: @question, format: "json"
      response.should be_success
      response.content_type.should eq Mime::JSON
    end
    
    it "creates an impression record" do
      expect {
        get :show, id: @question
      }.to change(Impression, :count).by(1)
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template :index
    end
    
    it "renders index.js template" do
      get :index, format: "js"
      response.should be_success
      response.content_type.should eq Mime::JS
    end
  end
  
  describe "GET popular" do
    it "renders popular template" do
      get :popular
      response.should render_template :popular
    end
  end
  
  describe "GET unanswered" do
    it "renders unanswered template" do
      get :unanswered
      response.should render_template :unanswered
    end
  end
  
  describe "GET related" do
    it "renders related template" do
      get :related, id: @question.id
      response.should render_template :related
    end
  end

  describe "GET new" do
    it "assigns a new question as @question" do
      get :new
      assigns(:question).should be_a_new(Question)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "saved a new question to db" do
        expect {
          post :create, question: attributes_for(:question), user: @user1
        }.to change(Question, :count).by(1)
      end
      
      it "also creates question point" do
        expect {
          post :create, question: attributes_for(:question), user: @user1
        }.to change(Point, :count).by(1)
      end

      it "assigns a newly created question as @question" do
        post :create, question: attributes_for(:question), user: @user1
        assigns(:question).should be_a(Question)
        assigns(:question).should be_persisted
      end

      it "redirects to the created question" do
        post :create, question: attributes_for(:question), user: @user1
        response.should redirect_to(Question.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved question as @question" do
        Question.any_instance.stub(:save).and_return(false)
        post :create, question: attributes_for(:question), user: @user1
        assigns(:question).should be_a_new(Question)
      end

      it "re-renders the 'new' template" do
        Question.any_instance.stub(:save).and_return(false)
        post :create, question: attributes_for(:question), user: @user1
        response.should render_template("new")
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
      post :create, question: attributes_for(:question), user: @user1
      ActionMailer::Base.deliveries.count.should eq 1
    end
  end

  describe "PUT update" do
    before(:each) do
      @question = create(:question, user: @user1, title: "now im hooking it!", body: "ball is going to the left")
    end
    
    it "assigns the requested question as @question" do
      put :update, id: @question, question: attributes_for(:question)
      assigns(:question).should eq(@question)
    end
    
    describe "with valid params" do
      it "updates the requested question" do
        put :update, id: @question, question: attributes_for(:question, title: "Shanking now, great!"), user: @user1
        @question.reload
        @question.title.should eq("Shanking now, great!")
      end

      it "redirects to the post" do
        put :update, id: @question, question: attributes_for(:question, title: "Shanking now, great!"), user: @user1
        @question.reload
        response.should redirect_to @question
      end
    end

    describe "with invalid params" do
      it "doesn not change @question attributes" do
        put :update, id: @question, question: attributes_for(:question, title: ""), user: @user1
        @question.reload
        @question.title.should_not eq("")
      end
    end
  end

  describe "DELETE destroy" do
    before(:each) do
      @question = create(:question, user: @user1)
    end
    
    it "destroys the requested question" do
      expect {
        delete :destroy, id: @question
      }.to change(Question, :count).by(-1)
    end

    it "redirects to the questions list" do
      delete :destroy, id: @question
      response.should redirect_to root_path
    end
    
    it "delets association: point" do
      post :create, question: attributes_for(:question), user: @user1
      expect {
        delete :destroy, id: Question.last
      }.to change(Point, :count).by(-1)
    end
    
    it "deletes association: impressions" do
      post :create, question: attributes_for(:question), user: @user1
      get :show, id: Question.last
      expect {
        delete :destroy, id: Question.last
      }.to change(Impression, :count).by(-1)
    end
  end
end
