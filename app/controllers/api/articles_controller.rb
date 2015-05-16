module Api
  class ArticlesController < ApplicationController
    
    before_action :authenticate_user!, except: [:show, :index]
    load_and_authorize_resource except: [:show, :index]
    
    def show
      @article = Article.find params[:id]
      ImpressionRepository.create(@article, request)
      render json: @article
    end
  
    def index
      @articles = Article.state(Article::PUBLISHED).order('published_at DESC').paginate(page: params[:page], per_page: 20)
      render json: @articles
    end
  
    def create
      @article = current_user.articles.build(article_params)
      if @article.save
        PointRepository.create(@article.user, @article)
        render json: @article
      else
        render json: { errors: @article.errors.full_messages }, status: 422
      end
    end
  
    def update
      @article = Article.find params[:id]
      if @article.update_attributes article_params
        render json: @article, status: 200
      else
        render json: { errors: @article.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @article = Article.find params[:id]
      if @article.destroy
        render json: {}, status: 200
      else
        render json: { errors: @article.errors.full_messages }, status: 422
      end
    end
  
    def admin
      # TODO: Needs to be in an Interactor
      articles = Proc.new { |state, order| Article.state(state).order("#{order} DESC").paginate(page: params[:page], per_page: 20) }
      @published = articles.call(Article::PUBLISHED, 'published_at')
      @approved = articles.call(Article::APPROVED, 'created_at')
      @submitted = articles.call(Article::SUBMITTED, 'created_at')
      render json: { published: @published, approved: @approved, submitted: @submitted }, status: 200
    end
  
    def draft
      transition :draft
    end
  
    def submit
      transition :submit
    end
  
    def approve
      transition :approve
    end
  
    def publish
      transition :publish do |article|
        repo = ActivityRepository.new article
        repo.generate :create, owner: current_user, recipient: article.user 
      end
    end
  
    def discard
      transition :discard
    end
  
    protected
    
    def transition(method)
      article = Article.find params[:id]
      success, message = ArticleRepository.transition article, method
      if success
        yield article if block_given?
        render json: article, status: 200
      else
        render json: { errors: message }, status: 422
      end
    end
    
    def article_params
      params.require(:article).permit(:title, :body, :points, :user_id, :cover_image, :published_at)
    end
  end
end