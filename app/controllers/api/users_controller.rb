module Api
  class UsersController < ApplicationController
  
    # before_filter :authenticate_user!, except: [:index, :show]
    #   load_and_authorize_resource except: [:index, :show]
    #   before_filter :set_user, except: :index
  
    def show
      @decorator = UserDecorator.new(@user)
      @points = Point.find_points(@decorator)
    end
  
    def index
      @users = User.order("rank").reject { |n| n.rank == 0 }#.paginate(page: params[:page], per_page: 50)
    end
  
    def answers
      @answers = @user.answers.order("created_at desc").paginate(page: params[:page], per_page: 10).includes(:question)
    end
  
    def questions
      @questions = @user.questions.order("created_at desc").paginate(page: params[:page], per_page: 10)
    end
  
    def articles
      @articles = @user.articles.paginate(page: params[:page], per_page: 10)
    end
  
    def welcome
    end
  
    def set_user
      @user ||= User.find(params[:id])
    end
  end
end