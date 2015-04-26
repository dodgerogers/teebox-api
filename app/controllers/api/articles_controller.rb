module Api
  class ArticlesController < ApplicationController
    include Teebox::Commentable
  
    # before_filter :authenticate_user!, except: [:index, :show]
    #   before_filter :set_article, except: [:new, :index, :create, :admin]
    #   load_and_authorize_resource except: [:index, :show]
  
    def new
      @article = Article.new
    end
  
    def show
      @latest = Article.state(Article::PUBLISHED).where('id not in (?)', @article.id).order('updated_at DESC').sample(3)
      ImpressionRepository.create(@article, request)
    end
  
    def index
      @articles = Article.state(Article::PUBLISHED).order('published_at DESC').paginate(page: params[:page], per_page: 20)
    end
  
    def edit
    end
  
    def create
      @article = current_user.articles.build(params[:article].except!(:state))
      if @article.save
        PointRepository.create(@article.user, @article)
        redirect_to @article, notice: 'Article Sucessfully created'
      else
        render :new, notice: 'Please try again'
      end
    end
  
    def update
      if @article.update_attributes(params[:article].except!(:state))
        redirect_to edit_article_path(@article), notice: 'Updated successfully'
      else
        render :edit, notice: 'Please try again'
      end
    end
  
    def destroy
      if @article.destroy
        redirect_to articles_path, notice: 'Article deleted'
      else
        redirect_to articles_path, notice: 'Please try again'
      end
    end
  
    def admin
      articles = Proc.new { |state, order| Article.state(state).order("#{order} DESC").paginate(page: params[:page], per_page: 20) }
      @published = articles.call(Article::PUBLISHED, 'published_at')
      @approved = articles.call(Article::APPROVED, 'created_at')
      @submitted = articles.call(Article::SUBMITTED, 'created_at')
    end
  
    def draft
      transition(@article, :draft)
    end
  
    def submit
      transition(@article, :submit)
    end
  
    def approve
      transition(@article, :approve, admin_articles_path)
    end
  
    def publish
      transition(@article, :publish, admin_articles_path) do
        repo = ActivityRepository.new(@article)
        repo.generate(:create, owner: current_user, recipient: @article.user)
      end
    end
  
    def discard
      transition(@article, :discard)
    end
  
    protected
  
    def transition(article, method, path=nil)
      success, message = ArticleRepository.transition(article, method)
      yield if block_given? && success
      redirect_to (path || edit_article_path(article)), notice: message
    end
  
    private
  
    def set_article
      @article = Article.find(params[:id])
    end
  end
end