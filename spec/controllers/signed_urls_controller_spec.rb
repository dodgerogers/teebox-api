require "spec_helper"

describe SignedUrlsController do
  before(:each) do
    @user1 = create(:user)
    @user1.confirm!
    sign_in @user1 
    @video = create(:video)
    @file = File.split(@video.file)[1]
  end
    
  describe "index" do
    it "creates policy document" do
      get :index, format: "json", doc: { title: @file }
      response.status.should eq 200
      response.content_type.should eq Mime::JSON
    end
    
    it "policy doc contains correct params" do
      get :index, format: "json", doc: { title: @file }
      policy = JSON.parse(response.body, symbolize_names: true)
      File.split(policy[:key])[1].should eq @file
      policy[:success_action_redirect].should eq "/"
    end
  end
end

  