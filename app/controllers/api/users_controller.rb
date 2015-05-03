module Api
  class UsersController < ApplicationController
    
    load_and_authorize_resource except: [:index, :show]
    before_action :set_user, only: [:show, :answers, :questions, :articles]
  
    def show
      render json: @user
    end
  
    def index
      @users = User.order("rank").reject { |n| n.rank == 0 }#.paginate(page: params[:page], per_page: 50)
      render json: @users
    end
  
    # TODO: These should all just hit the various resource index actions with a user id
    def answers
      @answers = @user.answers.order("created_at desc").paginate(page: params[:page], per_page: 10).includes(:question)
      render json: { answers: @answers }
    end
  
    def questions
      @questions = @user.questions.order("created_at desc").paginate(page: params[:page], per_page: 10)
      render json: { questions: @questions }
    end
  
    def articles
      @articles = @user.articles.paginate(page: params[:page], per_page: 10)
      render json: { articles: @articles }
    end
    
    private 
    
    def set_user
      @user = User.find params[:id]
    end
  end
end