require 'spec_helper'

describe Api::TagsController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @tag = create(:tag)
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email,
      search: 'driver'
    }
  end
  
  describe "GET show" do
    it "returns 200" do
      get :show, @params.merge(id: @tag.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'tag'
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'tags'
    end
  end

  describe "POST create" do
    context "succcess" do
      it 'returns 200 and tag' do
        get :create, @params.merge(tag: {name: 'Driver', explanation: "Longest club in the bag" })

        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'tag'
      end
    end

    context "failure" do
      it "returns 422 and errors" do
        Tag.any_instance.stub(:save).and_return(false)
        get :create, @params.merge(tag: { name: 'Driver', explanation: "Longest club in the bag" })

        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end

  describe "PUT update" do
    context "success" do
      it "returns 200 and tag" do
        put :update, @params.merge(id: @tag.id, tag: { name: "top"})
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'tag'
      end
    end

    context "failure" do
      it "return 422 and errors" do
        Tag.any_instance.stub(:save).and_return(false)
        put :update, @params.merge(id: @tag.id, tag: { name: "top"})
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end

  describe "DELETE destroy" do
    context "success" do
      it "destroys the requested question" do
        delete :destroy, @params.merge(id: @tag.id)
      
        response.status.should eq 200
      end
    end
    
    context "failure" do
      it "returns 422" do
        Tag.any_instance.stub(:destroy).and_return(false)
        delete :destroy, @params.merge(id: @tag.id)

        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "question_tags" do
    it "orders tags by name" do
      get :question_tags
      
      response.status.should eq 200
    end
  end
end
