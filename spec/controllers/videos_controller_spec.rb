require 'spec_helper'

describe Api::VideosController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @video = create(:video, user_id: @user.id)
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email
    }
  end
  
  describe "GET show" do
   it "returns 200" do
      get :show, @params.merge(id: @video.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'video'
    end
  end
  
  describe "GET index" do
    it "returns 200 and videos" do
      get :index, @params
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'videos'
    end
  end

  describe "POST create" do
    before :each do 
      @file = 'edited_driver_swing.m4v'
      @screenshot = 'seven_iron.m4v'
    end
    
    describe "success" do
      it "returns 200, video and calls transcoder repo" do
        TranscoderRepository.should_receive(:generate).and_return(true)
        
        post :create, @params.merge(video: { file: @file, screenshot: @screenshot })
        
        response.should be_success
        result = JSON.parse response.body
        result.should include 'video'
      end
    end

    describe "failure" do
      it "returns 422 and errors" do
        Video.any_instance.stub(:save).and_return(false)
        
        post :create, @params.merge(video: { file: @file, screenshot: @screenshot })
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "PUT update" do
    context "success" do
      it "returns 200 and video" do
        put :update, @params.merge(id: @video.id, video: { name: 'Video title' })
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'video'
      end
    end

     context "failure" do
       it "returns 422 and errors" do
         Video.any_instance.stub(:update_attributes).and_return(false)
         
         put :update, @params.merge(id: @video.id, video: { name: 'Video title' })
         
         response.status.should eq 422
         result = JSON.parse response.body
         result.should include 'errors'
       end
     end
   end

  describe "DELETE destroy" do
    context "success" do
      it "returns 200" do
        Video.any_instance.stub(:delete_aws_key).and_return(true)
        delete :destroy, @params.merge(id: @video.id)
        
        response.should be_success
      end
    end
    
    context "failure" do
      it "returns 422 and errors" do
        Video.any_instance.stub(:destroy).and_return false
        delete :destroy, @params.merge(id: @video.id)
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
end
