module Api
  class QuestionsController < ApplicationController
    load_and_authorize_resource except: [:index, :show, :related]
  
    def index
      @questions = Question.all.includes(:user, :videos, :answers, :comments).paginate(page: params[:page], per_page: 20)
      render json: @questions
    end
  
    def show
      @question = Question.find(params[:id])
      ImpressionRepository.create @question, request
      render json: @question
    end
  
    def create
      @question = current_user.questions.build question_params
      if @question.save
        PointRepository.create @question.user, @question
        NotificationMailer.delay.new_question_email @question
        render json: @question
      else
        render json: { errors: @question.errors.full_messages }, status: 422
      end
    end
  
    def update 
      @question = Question.find(params[:id])
      if @question.update_attributes question_params
        render json: @question
      else
        render json: { errors: @question.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @question = Question.find(params[:id])
      if @question.destroy
        render json: {}, status: :ok
      else
        render json: { errors: @question.errors.full_messages }, status: 422
      end
    end
  
    # Convert these to a search_by repo method
    #     def unanswered
    #       @unanswered = Question.unanswered.includes(:user, :videos).paginate(page: params[:page], per_page: 20)
    #     end
    # 
    #     def popular
    #       @popular = Question.popular.includes(:user, :videos).paginate(page: params[:page], per_page: 20)
    #     end
  
    #     def related
    #       @related = Question.related_questions 
    #       respond_to do |format|
    #         format.html { render layout: false }
    #        end
    #       render json: @related
    #     end
  
    private
    
    def question_params
      params.require(:question).permit(:title, :body, :correct, :tag_tokens, :video_list)
    end
  end
end