module Api
  class UsersController < ApplicationController
  
    # before_filter :authenticate_user!, except: [:index, :show]
    #   load_and_authorize_resource except: [:index, :show]
    #   before_filter :set_user, except: :index
  
    def show
      @user = User.find(params[:id])
      render json: @user
    end
  
    def index
      @users = User.order("rank").reject { |n| n.rank == 0 }#.paginate(page: params[:page], per_page: 50)
      render json: @users
    end
  
    def answers
      @answers = @user.answers.order("created_at desc").paginate(page: params[:page], per_page: 10).includes(:question)
      render json: @answers
    end
  
    def questions
      @questions = @user.questions.order("created_at desc").paginate(page: params[:page], per_page: 10)
      render json: @questions
    end
  
    def articles
      @articles = @user.articles.paginate(page: params[:page], per_page: 10)
      render json: @articles
    end
  end
end