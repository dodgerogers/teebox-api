require 'spec_helper'

describe Api::UsersController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email,
      search: 'driver'
    }
  end
  
  describe "GET index" do
    it "returns 200 and user" do
      get :index
      response.status.should eq 200
    end
  end
  
  describe "GET show" do
    it "returns 200 and user" do
      get :show, @params.merge(id: @user.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'user'
    end
  end
  
  describe "GET users objects " do
    it "renders answers" do
      get :answers, @params.merge(id: @user.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'answers'
    end
    
    it "renders questions" do
      get :questions, @params.merge(id: @user.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'questions'
    end
    
    it "renders articles" do
      get :articles, @params.merge(id: @user.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'articles'
    end
  end
end
