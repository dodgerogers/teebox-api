require 'spec_helper'

describe Api::CommentsController do
  include Devise::TestHelpers
  include AnswerHelper
  before(:each) do
    @user = create(:user)
    @user2 = create(:user)
    @user.confirm!
    @user2.confirm!
    @commentable = create(:question, id: 1, title: "slicing the ball", body: "the ball cuts")
    @comment = create(:comment, user_id: @user.id, commentable_id: @commentable.id)
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email, 
    }
  end
  
  describe "GET show" do
    it "assigns a new decorator as @decorator" do
      get :show, @params.merge(id: @comment.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'comment'
    end
  end
        
  describe "POST create on commentable" do
     context "success" do
      it "returns 200 and comment" do
        post :create, @params.merge(comment: { content: "this is a valid comment", commentable_id: @commentable.id, commentable_type: @commentable.class.to_s })
       
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'comment'
      end
      
      it "calls point and notification creation methods when owner is not equal to the recipient" do        
        ActivityFactory.any_instance.should_receive(:generate).and_return(create(:activity))
        
        post :create, @params.merge(comment: { content: "this is a valid comment", commentable_id: @commentable.id, commentable_type: @commentable.class.to_s })
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'comment'
      end
    end
    
    context "failure" do
      it "assigns a newly created but unsaved comment as @comment" do
        Comment.any_instance.stub(:save).and_return(false)
        post :create, @params.merge(commentable_id: @commentable.id, comment: { content: "this is a valid comment" })
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
    
  describe "DELETE destroy" do
    context "success" do
      it 'returns 200' do
        delete :destroy, @params.merge(id: @comment.id)
      
        response.status.should eq 200
      end
    end
    
    context "failure" do
      it 'returns 422 and errors' do
        Comment.any_instance.stub(:destroy).and_return(false)
        delete :destroy, @params.merge(id: @comment.id)
      
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
end
