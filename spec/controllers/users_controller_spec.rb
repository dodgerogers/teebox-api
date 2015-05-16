require 'spec_helper'

describe Api::UsersController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email
    }
  end
  
  describe "GET index" do
    it "returns 200 and users when repo succeeds" do
      get :index, @params
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'users'
    end
    
    it "returns 422 repo fails" do
      UserRepository.any_instance.stub(:success?).and_return false
      UserRepository.any_instance.should_receive(:errors).and_return message: "Errors"
      
      get :index, @params
      response.status.should eq 422
      result = JSON.parse response.body
      result.should include 'errors'
    end
  end
  
  describe "GET show" do
    it "returns 200 and user" do
      get :show, @params.merge(id: @user.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'user'
    end
    
    it "returns 422 and errors" do
      get :show, @params.merge(id: 99999)
      
      response.status.should eq 404
      result = JSON.parse response.body
      result.should include 'errors'
    end
  end
end
