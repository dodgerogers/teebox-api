require 'spec_helper'

describe ArticlesController do
  include Devise::TestHelpers
  before(:each) do
    @user = create(:user)
    @user.confirm!
    sign_in @user
    @article = create(:article, user: @user)
    controller.stub!(:current_user).and_return(@user)
    @vote = attributes_for(:vote, votable_id: @article.id, votable_type: @article.class.to_s, user: @user, value: 1)
    @request.env['HTTP_REFERER'] = "/articles/#{@article.id}/"
  end
  
  describe "GET show" do
    it "assigns a new article as @article" do
      get :show, id: @article
      assigns(:article).should eq(@article)
    end
    
    it "renders the show template" do
      get :show, id: @article
      response.should render_template :show
    end
    
    it "creates an impression record" do
      expect {
        get :show, id: @article
      }.to change(Impression, :count).by(1)
    end
  end
  
  describe "GET index" do
    it "renders index template" do
      get :index
      response.should render_template :index
    end
  end
  
  describe "GET admin_articles" do
    context 'as admin' do
      before(:each) do
        @user = create(:user, role: 'admin')
        @user.confirm!
        sign_in @user
        @article = create(:article, user: @user)
        controller.stub!(:current_user).and_return(@user)
      end
      
      it "renders index template" do
        get :admin
        response.should render_template :admin
      end
    end
    
    context 'as standard user' do
      before(:each) do
        @user1 = create(:user, role: 'standard')
        @user1.confirm!
        sign_in @user1
        controller.stub!(:current_user).and_return(@user1)
      end
      
      it "redirects to the home page" do
        get :admin
        response.should redirect_to :root
      end
    end
  end

  describe "GET new" do
    it "assigns a new article as @article" do
      get :new
      assigns(:article).should be_a_new(Article)
    end
  end

  describe "POST create" do
    describe "with valid params" do
      it "saved a new article to db" do
        expect {
          post :create, article: attributes_for(:article), user: @user
        }.to change(Article, :count).by(1)
      end
      
      it "also creates article point" do
        expect {
          post :create, article: attributes_for(:article), user: @user
        }.to change(Point, :count).by(1)
      end

      it "assigns a newly created article as @article" do
        post :create, article: attributes_for(:article), user: @user
        assigns(:article).should be_a(Article)
        assigns(:article).should be_persisted
      end

      it "redirects to the created article" do
        post :create, article: attributes_for(:article), user: @user
        response.should redirect_to(Article.last)
      end
    end

    describe "with invalid params" do
      it "assigns a newly created but unsaved article as @article" do
        Article.any_instance.stub(:save).and_return(false)
        post :create, article: attributes_for(:article), user: @user
        assigns(:article).should be_a_new(Article)
      end

      it "re-renders the 'new' template" do
        Article.any_instance.stub(:save).and_return(false)
        post :create, article: attributes_for(:article), user: @user
        response.should render_template("new")
      end
    end
  end

  describe "PUT update" do
    before(:each) do
      @article = create(:article, user: @user, title: "now im hooking it!", body: "ball is going to the left")
    end
    
    it "assigns the requested article as @article" do
      put :update, id: @article, article: attributes_for(:article)
      assigns(:article).should eq(@article)
    end
    
    describe "with valid params" do
      it "updates the requested article" do
        put :update, id: @article, article: attributes_for(:article, title: "Shanking now, great!"), user: @user
        @article.reload
        @article.title.should eq("Shanking now, great!")
      end

      it "redirects to the post" do
        put :update, id: @article, article: attributes_for(:article, title: "Shanking now, great!"), user: @user
        @article.reload
        response.should redirect_to edit_article_path(@article)
      end
    end

    describe "with invalid params" do
      it "doesn not change @article attributes" do
        put :update, id: @article, article: attributes_for(:article, title: ""), user: @user
        @article.reload
        @article.title.should_not eq("")
      end
    end
  end
  
  describe "DELETE destroy" do
    before(:each) do
      @article = create(:article, user: @user)
    end
    
    context 'successfull' do
      it "destroys the requested article" do
        expect {
          delete :destroy, id: @article
        }.to change(Article, :count).by(-1)
      end

      it "redirects to index" do
        delete :destroy, id: @article
        response.should redirect_to articles_path
      end
    
      it "delets association: point" do
        post :create, article: attributes_for(:article), user: @user
        expect {
          delete :destroy, id: Article.last
        }.to change(Point, :count).by(-1)
      end
    
      it "deletes association: impressions" do
        post :create, article: attributes_for(:article), user: @user
        get :show, id: Article.last
        expect {
          delete :destroy, id: Article.last
        }.to change(Impression, :count).by(-1)
      end
    end
    
    context 'failure' do
      before(:each) do
        Article.any_instance.stub(:destroy).and_return(false)
      end
      
      it 'does not delete article' do
         expect {
          delete :destroy, id: @article
        }.to_not change(Article, :count).by(-1)
      end
      
      it 're renders the article' do
        delete :destroy, id: @article
        response.should redirect_to articles_path
      end
    end
  end
  
  describe 'transitions' do
    context 'successful' do
      before(:each) do
        @article = create(:article)
      end
    
      context 'draft' do
        it 'redirects to article on success' do
          Article.any_instance.stub(:draft).and_return(true, 'Successful')
          
          put :draft, id: @article
        
          response.status.should eq 302
          response.should redirect_to edit_article_path(@article)
        end
      end
    
      context 'submit' do
        it 'redirects to article on success' do
          Article.any_instance.stub(:submit).and_return(true, 'Successful')
          
          put :submit, id: @article
        
          response.status.should eq 302
          response.should redirect_to edit_article_path(@article)
        end
      end
    
      context 'approve' do
        it 'redirects to article on success' do
          Article.any_instance.stub(:approve).and_return(true, 'Successful')
          
          put :approve, id: @article
        
          response.status.should eq 302
          response.should redirect_to admin_articles_path
        end
        
        it 'redirects to unauthorized for standard user' do
          standard_user = create(:user, role: User::STANDARD)
          standard_user.confirm!
          sign_in standard_user
          
          controller.stub!(:current_user).and_return(standard_user)
          
          put :approve, id: @article
          
          response.should redirect_to root_path
        end
      end
    
      context 'publish' do
        it 'redirects to admin article index on success' do
          Article.any_instance.stub(:publish).and_return(true, 'Successful')
          
          put :publish, id: @article
        
          response.status.should eq 302
          response.should redirect_to admin_articles_path
        end
        
        it "calls point and notification creation methods when differing answer and question users" do
          Article.any_instance.stub(:publish).and_return(true, 'Successful')
          Activity.destroy_all
          ActivityRepository.any_instance.should_receive(:generate).and_return(create(:activity))

          put :publish, id: @article

          Activity.all.size.should eq 1
        end
        
        it 'redirects to unauthorized for standard user' do
          standard_user = create(:user, role: User::STANDARD)
          standard_user.confirm!
          sign_in standard_user
          
          controller.stub!(:current_user).and_return(standard_user)
          
          put :publish, id: @article
        
          response.should redirect_to root_path
        end
      end
    
      context 'discard' do
        it 'redirects to article on success' do
          Article.any_instance.stub(:discard).and_return(true, 'Successful')
          
          put :discard, id: @article
        
          response.status.should eq 302
          response.should redirect_to edit_article_path(@article)
        end
      end
    end
  end
end