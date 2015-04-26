require 'spec_helper'

describe UsersController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    sign_in @user
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template :index
    end
  end
  
  describe "GET show" do
    it "assigns a new user as @user" do
      get :show, id: @user
      assigns(:user).should eq(@user)
    end
    
    it "renders the show template" do
      get :show, id: @user
      response.should render_template :show
    end
  end
  
  describe "GET users objects " do
    it "renders answers template" do
      get :answers, id: @user.id
      response.should render_template :answers
    end
    
    it "renders questions template" do
      get :questions, id: @user.id
      response.should render_template :questions
    end
    
    it "renders articles template" do
      get :articles, id: @user.id
      response.should render_template :articles
    end
  end
  
  describe "welcome_page" do
    it "redirects to welcome path" do
      get :welcome, id: @user.id
      response.should render_template :welcome
    end
  end
end
