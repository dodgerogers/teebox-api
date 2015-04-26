module Api
  class SearchController < ApplicationController
    # before_filter :set_articles
  
    def index
      @result = GlobalSearch.call(search_params)
      if @result.success?
        render json: @result
      else
        render json: { message: @result.message}, status: 422
      end
    end
  
    private
  
    def search_params
      params.slice(:search, *GlobalSearch::PAGE_PARAMS)
    end
  
    def set_articles
      @articles = Article.state(Article::PUBLISHED).order('published_at DESC').sample(2)
    end
  end
end