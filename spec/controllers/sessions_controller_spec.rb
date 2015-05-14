require "spec_helper"

describe Api::SessionsController do
  before(:each) do
    @user = create :user # Creates user with a valid authentication token
  end
  
  describe "sign_in" do
    context 'success' do
      it 'returns 200 & generates a new token' do
        @user.invalidate_token!
        
        get :create, username: @user.username, password: @user.password
        
        response.should be_success
        result = JSON.parse response.body
        user_token = result["user_token"]
        user_token.should include "authentication_token"
        user_token["authentication_token"].should_not be_nil
      end
      
      it 'returns 200 if you already have a token' do
        valid_existing_token = 'already-have-a-valid-token'
        @user.authentication_token = valid_existing_token
        @user.save
        
        get :create, username: @user.username, password: @user.password
        
        response.status.should eq 200
        result = JSON.parse response.body
        
        user_token = result["user_token"]
        user_token.should include "authentication_token"
        user_token["authentication_token"].should eq valid_existing_token
      end
    end
    
    context 'failure' do
      it 'returns 401' do
        get :create, username: @user.username, password: 'incorrect password'
        
        response.status.should eq 401
        result = JSON.parse response.body
        result.should include "errors"
        result.should_not include "authentication_token"
      end
    end
  end
end
    