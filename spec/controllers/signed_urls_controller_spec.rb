require "spec_helper"

describe Api::SignedUrlsController do
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @video = create(:video)
    @file = File.split(@video.file)[1]
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email,
      search: 'driver'
    }
  end
    
  describe "index" do
    it "creates policy document" do
      get :index, @params.merge(doc: { title: @file })
      
      response.status.should eq 200
    end
    
    it "policy doc contains correct params" do
      get :index, @params.merge(doc: { title: @file })
      
      policy = JSON.parse(response.body, symbolize_names: true)
      File.split(policy[:key])[1].should eq @file
      policy[:success_action_redirect].should eq "/"
    end
  end
end

  