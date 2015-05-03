require "spec_helper"

describe Api::PointsController do
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email, 
    }
  end
  
  describe "GET index" do
    it "returns 200" do
      get :index, @params
      
      result = JSON.parse response.body
      result.should include 'points'
      response.status.should eq 200
    end
  end
  
  describe "GET breakdown" do
    it "returns 200" do
      get :breakdown, @params
      
      result = JSON.parse response.body
      result.should include 'points'
      response.status.should eq 200
    end
  end
end