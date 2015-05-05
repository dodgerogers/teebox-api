require "spec_helper"

describe Api::SessionsController do
  before(:each) do
    @user = create :user # Creates user with a valid authentication token
  end
  
  describe "sign_in" do
    context 'success' do
      it 'returns 200 generates a new token' do
        token_before = @user.authentication_token
        User.any_instance.stub(:authentication_token).and_return nil
        
        get :create, username: @user.username, password: @user.password
        
        response.should be_success
        result = JSON.parse response.body
        result.should include "authentication_token"
        result["authentication_token"].should_not eq token_before
      end
      
      it 'returns 200 if you already have a token' do
        @user.authentication_token = 'already-have-a-valid-token'
        
        get :create, username: @user.username, password: @user.password
        
        response.status.should eq 200
        result = JSON.parse response.body
        result["message"].should include "You are already signed in"
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
    