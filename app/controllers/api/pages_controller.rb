module Api
  class PagesController < ApplicationController
    caches_page :info, :about, :terms
  
    def info
    end
  
    def terms
    end
  
    def about
      @user = User.where(username: "dodgerogers")[0]
    end
  
    def sitemap
      @static_pages = [root_path, info_path, users_path, root_path, unanswered_path, popular_path, sitemap_path, about_path, terms_path]
      @questions = Question.order("created_at desc")
      @tags = Tag.order(:name)
      respond_to do |format|
        format.html
        format.xml
      end
    end
  end
end