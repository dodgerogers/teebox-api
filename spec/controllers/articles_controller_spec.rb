require 'spec_helper'

describe Api::ArticlesController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    @article = create(:article, user: @user)
    @params = { 
      user_token: @user.authentication_token, 
      user_email: @user.email, 
    }
  end
  
  describe "GET show" do
    it "returns article and 200" do
      get :show, @params.merge(id: @article.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'article'
    end
    
    it "calls an impression create" do
      ImpressionRepository.should_receive(:create).with(@article, request).and_return(true)
      
      get :show, @params.merge(id: @article.id)
      
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'article'
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.status.should eq 200
      result = JSON.parse response.body
      result.should include 'articles'
    end
  end
  
  describe "GET admin_articles" do
    context 'as admin' do
      before(:each) do
        @admin_user = create(:user, role: 'admin')
        @admin_user.confirm!
        @article = create(:article, user: @user)
        @params = { 
          user_token: @admin_user.authentication_token, 
          user_email: @admin_user.email, 
        }
      end
      
      it "renders index and 200" do
        get :admin, @params
        response.status.should eq 200
      end
    end
    
    context 'as standard user' do
      before(:each) do
        @standard_user = create(:user, role: 'standard')
        @standard_user.confirm!
        @params = { 
          user_token: @standard_user.authentication_token, 
          user_email: @standard_user.email, 
        }
      end
      
      it "renders json errors and 403" do
        get :admin, @params
        response.status.should eq 403
      end
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "returns 200 and article" do
        post :create, @params.merge(article: { title: "Some title", body: 'some body text', cover_image: 'image.jpg'})
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'article'
      end
    end

    describe "with invalid params" do
      it "returns 422 and errors" do
        Article.any_instance.stub(:save).and_return(false)
        post :create, @params.merge(article: { title: "Some title", body: 'some body text'})
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end

  describe "PUT update" do
    context "with valid params" do
      it "returns 200 and article" do
        put :update, @params.merge(id: @article, article: { title: "Shanking now, great!" })
        
        response.status.should eq 200
        result = JSON.parse response.body
        result.should include 'article'
      end
    end

    context "with invalid params" do
      it "returns 422 and errors" do
        Article.any_instance.stub(:save).and_return(false)
        put :update, @params.merge(id: @article, article: { title: "Shanking now, great!" })
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe "DELETE destroy" do
    context 'success' do
      it "returns 200" do
        delete :destroy, @params.merge(id: @article.id)
        response.status.should eq 200
      end
    end
    
    context 'failure' do
      it 'returns 422 and errors' do
        Article.any_instance.stub(:destroy).and_return(false)
        delete :destroy, @params.merge(id: @article.id)
        
        response.status.should eq 422
        result = JSON.parse response.body
        result.should include 'errors'
      end
    end
  end
  
  describe 'transitions' do
    context 'success' do
      context 'draft' do
        it 'returns 200' do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          
          put :draft, @params.merge(id: @article.id)
        
          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
      end
    
      context 'submit' do
        it 'returns 200' do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          
          put :submit, @params.merge(id: @article.id)
        
          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
      end
    
      context 'approve' do
        it 'returns 200' do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          
          put :approve, @params.merge(id: @article.id)
        
          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
        
        it 'returns 403 for unauthorized user' do
          standard_user = create(:user, role: User::STANDARD)
          standard_user.confirm!
          
          put :approve, { id: @article.id, user_token: standard_user.authentication_token, user_email: standard_user.email }
          
          response.status.should eq 403
          result = JSON.parse response.body
          result.should include 'errors'
        end
      end
    
      context 'publish' do
        it 'returns 200' do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          
          put :publish, @params.merge(id: @article.id)
        
          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
        
        it "calls point and notification creation methods when differing answer and question users" do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          ActivityRepository.any_instance.should_receive(:generate)

          put :publish, @params.merge(id: @article.id)

          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
        
        it 'redirects to unauthorized for standard user' do
          standard_user = create(:user, role: User::STANDARD)
          standard_user.confirm!
          
          put :publish, { id: @article.id, user_token: standard_user.authentication_token, user_email: standard_user.email }
          
          response.status.should eq 403
          result = JSON.parse response.body
          result.should include 'errors'
        end
      end
    
      context 'discard' do
        it 'redirects to article on success' do
          ArticleRepository.stub(:transition).and_return(true, 'Successful')
          
          put :discard, @params.merge(id: @article.id)
        
          response.status.should eq 200
          result = JSON.parse response.body
          result.should include 'article'
        end
      end
    end
  end
end