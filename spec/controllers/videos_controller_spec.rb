require 'spec_helper'

describe VideosController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    sign_in @user
    @video = create(:video, user_id: @user.id)
    controller.stub!(:current_user).and_return(@user)
  end
  
  describe "GET show" do
   it "assigns a new video as @video" do
      @video = create(:video)
      get :show, id: @video
      assigns(:video).should eq(@video)
    end
    
    it "renders the show template" do
      @video = create(:video)
      get :show, id: @video
      response.should render_template :show
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template :index
    end
  end

  describe "GET new" do
    it "assigns a new video as @video" do
      get :new
      assigns(:video).should be_a_new(Video)
    end
  end
  
  describe "GET edit" do
    it 'assigns video as @video' do
      get :edit, id: @video.id
      assigns(:video).should eq @video
    end
    
    it 'renders edit template' do
      get :edit, id: @video.id
      response.should render_template :edit
    end
  end

  describe "POST create" do
    before(:each) do
      TranscoderRepository.any_instance.stub(:generate).and_return(true)
    end
    
    describe "with valid params" do
      it "uploads the video file" do
        @file = fixture_file_upload('/files/edited_driver_swing.m4v', 'video/m4v')
        post :create, upload: @file
        response.should be_success
      end
      
      it "creates a new video" do
        expect {
          post :create, video: attributes_for(:video), user_id: @user
        }.to change(Video, :count).by(1)
      end

      it "assigns a newly created video as @video" do
        post :create, video: attributes_for(:video), user_id: @user
        assigns(:video).should be_a(Video)
        assigns(:video).should be_persisted
      end

      it "redirects to the video index" do
        post :create, video: attributes_for(:video), user_id: @user
        response.should redirect_to videos_path
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved video as @video" do
        Video.any_instance.stub(:save).and_return(false)
        post :create, video: attributes_for(:video), user_id: @user
        assigns(:video).should be_a_new(Video)
      end

      it "re-renders the 'new' template" do
        Video.any_instance.stub(:save).and_return(false)
        post :create, video: attributes_for(:video), user_id: @user
        response.should render_template :new
      end
    end
  end
  
  describe "PUT update" do
     it "assigns the requested video as @video" do
       put :update, id: @video, video: attributes_for(:video)
       assigns(:video).should eq(@video)
     end

     describe "with valid params" do
       it "updates the requested video" do
         put :update, id: @video, video: attributes_for(:video, name: "Shanking now, great!"), user: @user1
         @video.reload
         @video.name.should eq("Shanking now, great!")
       end

       it "redirects to the video" do
         put :update, id: @video, video: attributes_for(:video, name: "Shanking now, great!"), user: @user1
         @video.reload
         response.should redirect_to @video
       end
     end

     describe "failure" do
       before(:each) do
         Video.any_instance.stub(:update_attributes).and_return(false)
       end
       
       it "does not change video attributes" do
        put :update, id: @video, video: attributes_for(:video, name: 'New name which will not save'), user: @user1
        @video.reload
        @video.name.should_not eq("")
       end
       
       it "renders the edit page" do
        put :update, id: @video, video: attributes_for(:video, name: 'New name which will not save'), user: @user1
        response.should render_template :edit
       end
     end
   end

  describe "DELETE destroy" do
    before(:each) do
      @video = create(:video)
      Video.any_instance.stub(:delete_key).and_return(@video)
    end
    
    it "destroys successfully" do
      expect {
        delete :destroy, id: @video
      }.to change(Video, :count).by(-1)
    end

    it "redirects to videos#index" do
      delete :destroy, id: @video
      response.should redirect_to videos_url
    end
  end
end
