require 'spec_helper'

describe SearchController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    sign_in @user
    
    controller.stub!(:current_user).and_return(@user)
    @request.env['HTTP_REFERER'] = "/"
  end

  describe "GET search" do
    before(:each) do
      @article1 = create(:article, user: @user, title: "Driver article")
      @article2 = create(:article, user: @user, title: "Putting article")
      @article3 = create(:article, user: @user, title: "Chipping article")

      @question1 = create(:question, user: @user, title: "How do i improve my driver")
      @question2 = create(:question, user: @user, title: "How do i improve my chipping")
      @question3 = create(:question, user: @user, title: "Tiger woods through the years")
      
      @params = { "search" => 'driver' }
    end
    
    context 'with valid params' do
      it "with valid params assigns results and renders index" do
        collection = { 
          articles: [@article1], 
          questions: [@question1] 
        }
        
        result = mock()
        GlobalSearch.should_receive(:call).with(@params).and_return(result)
        result.should_receive(:success?).and_return(true)
      
        get :index, @params
        response.should render_template :index
      end
    end
    
    context 'invalid params' do
      it 'renders the root path' do
        result = mock()
        GlobalSearch.should_receive(:call).with(@params).and_return(result)
        result.should_receive(:success?).and_return(false)
        result.should_receive(:message).and_return('failure')
        
        get :index, @params
        response.should redirect_to root_path 
      end
    end 
  end
end