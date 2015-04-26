module Api
  class QuestionsController < ApplicationController
    include Teebox::Commentable
  
    # before_filter :authenticate_user!, except: [:index, :show, :popular, :unanswered, :related]
    #   before_filter :set_question, only: [:show, :related]
    #   before_filter :set_articles, only: [:show, :index]
    #   load_and_authorize_resource except: [:index, :show, :related]
  
    def index
      @questions = Question.all.includes(:user, :videos).paginate(page: params[:page], per_page: 20)
      render json: @questions
    end
  
    def show
      @question = Question.find(params[:id])
      render json: @question
      # @answer = Answer.new
      #     @answers = @decorator.answers.includes(:user, :question).by_votes
      #     ImpressionRepository.create(@decorator, request)
    end
  
    def create
      # @question = current_user.questions.build(params[:question])
      @question = Question.new(params[:question])
      if @question.save
        # PointRepository.create(@question.user, @question)
        #       NotificationMailer.delay.new_question_email(@question)
        render json: @question
      else
        render json: {message: @question.errors.full_messages}, status: 422
      end
    end
  
    # def edit
    #     @question = Question.find(params[:id])
    #   end
  
    def update 
      @question = Question.find(params[:id])
      respond_to do |format|
        if @question.update_attributes(params[:question])
          render json: @question
        else
          render json: { message: @question.errors.full_messages }, status: 422
        end
      end
    end
  
    def destroy
      @question = Question.destroy(params[:id])
      if @question.destroy
        render json: {}, status: :ok
      else
        render json: { message: @question.errors.full_messages }, status: 422
      end
    end
  
    def unanswered
      @unanswered = Question.unanswered.includes(:user, :videos).paginate(page: params[:page], per_page: 20)
    end

    def popular
      @popular = Question.popular.includes(:user, :videos).paginate(page: params[:page], per_page: 20)
    end
  
    def related
      @related = Question.related_questions 
      # respond_to do |format|
      #       format.html { render layout: false }
      #     end
      render json: @related
    end
  
    private
  
    # def set_question
    #     question = Question.find(params[:id])
    #     @decorator ||= Questions::ShowDecorator.new(question)
    #   end
    #   
    #   def set_articles
    #     @articles = Article.state(Article::PUBLISHED).order('published_at DESC').sample(2)
    #   end
  end
end