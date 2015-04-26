require 'spec_helper'

describe CommentsController do
  include Devise::TestHelpers
  include AnswerHelper
  before(:each) do
    @user = create(:user)
    @user2 = create(:user)
    @user.confirm!
    @user2.confirm!
    sign_in @user
    sign_in @user2
    @commentable = create(:question, id: 1, title: "slicing the ball", body: "the ball cuts")
    @comment = create(:comment, user_id: @user.id, commentable_id: @commentable.id)
    @vote = attributes_for(:comment_vote, votable_id: @comment.id, user_id: @user2)
    controller.stub!(:current_user).and_return(@user)
    @request.env['HTTP_REFERER'] = "http://test.host/questions/#{@commentable.id}"
  end
  
  subject { @comment }
  
  describe "GET show" do
    it "assigns a new decorator as @decorator" do
      get :show, id: @comment
      assigns(:comment).should eq(@comment)
    end
    
    it "renders the show template" do
      get :show, id: @comment
      response.should render_template :show
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index, question_id: @commentable.id
      response.should render_template :index
    end
  end
        
  describe "POST create on question" do
     describe "with valid params" do
      it "creates a new comment" do
        expect {
          post :create, question_id: @commentable.id, comment: attributes_for(:comment)
        }.to change(Comment, :count).by(1)
      end

      it "assigns a newly created comment as @comment" do
        post :create, question_id: @commentable.id, comment: attributes_for(:comment)
        assigns(:comment).should be_a(Comment)
        assigns(:comment).should be_persisted
      end
      
      it "redirects to the commentable question" do
        post :create, question_id: @commentable.id, comment: attributes_for(:comment), commentable: @commentable
        response.should redirect_to("http://test.host/questions/#{@commentable.id}")
      end
      
      it "calls point and notification creation methods when owner is not equal to the recipient" do        
        Activity.destroy_all
        ActivityRepository.any_instance.should_receive(:generate).and_return(create(:activity))
        
        post :create, question_id: @commentable.id, comment: attributes_for(:comment), commentable: @commentable
        
        Activity.all.size.should eq 1
      end
    end
    
    describe "with invalid params" do
      it "assigns a newly created but unsaved comment as @comment" do
        Comment.any_instance.stub(:save).and_return(false)
        post :create, question_id: @commentable.id, comment: attributes_for(:comment), commentable: @commentable
        assigns(:comment).should be_a_new(Comment)
      end

      it "re-renders the 'new' template" do
        Comment.any_instance.stub(:save).and_return(false)
        post :create, question_id: @commentable.id, comment: attributes_for(:comment), commentable: @commentable
        response.should redirect_to("http://test.host/questions/#{@commentable.id}")
      end
    end
  end
    
  describe "DELETE destroy" do
    before(:each) do
      @comment = create(:comment, commentable_id: @commentable.id)
    end

    it "destroys the requested comment" do
      expect {
        delete :destroy, question_id: @commentable.id, id: @comment
      }.to change(Comment, :count).by(-1)
    end
  end
end
