require 'spec_helper'

describe Api::SearchController do
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

  describe "GET search" do
    before(:each) do
      @article1 = create(:article, user: @user, title: "Driver article")
      @article2 = create(:article, user: @user, title: "Putting article")
      @article3 = create(:article, user: @user, title: "Chipping article")

      @question1 = create(:question, user: @user, title: "How do i improve my driver")
      @question2 = create(:question, user: @user, title: "How do i improve my chipping")
      @question3 = create(:question, user: @user, title: "Tiger woods through the years")
    end
    
    context 'success' do
      it "returns 200 and result collection" do
        collection = { 
          articles: [@article1], 
          questions: [@question1] 
        }
        
        result = double('result', collection: collection, success?: true, total: collection.values.map(&:size).reduce(:+))
        GlobalSearch.should_receive(:call).and_return(result)
        
        get :index, @params
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'collection'
        result.should include 'total'
      end
    end
    
    context 'failure' do
      it 'returns 422 and errors' do
        result = double('result', success?: false, message: 'failure')
        GlobalSearch.should_receive(:call).and_return(result)
        
        get :index, @params
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'message'
      end
    end 
  end
end