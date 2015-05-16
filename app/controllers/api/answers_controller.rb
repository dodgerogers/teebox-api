module Api
  class AnswersController < ApplicationController
    
    load_and_authorize_resource #only: [:create, :update, :destroy, :correct]
    
    def show
      @answer = Answer.find params[:id]
      render json: @answer
    end
  
    def create
      @answer = current_user.answers.build answer_params
      if @answer.save
        PointRepository.create @answer.user, @answer
        repo = ActivityRepository.new @answer
        repo.generate :create, owner: current_user, recipient: @answer.question.user
        render json: @answer
      else
        render json: { errors: @answer.errors.full_messages }, status: 422
      end
    end
  
    def update
      @answer = Answer.find params[:id]
      if @answer.update_attributes answer_params
        render json: @answer
      else
        render json: { errors: @answer.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @answer = Answer.find params[:id]
      if @answer.destroy
         render json: {}, status: 200
      else
        render json: { errors: @answer.errors.full_messages }, status: 422
      end
    end
  
    def correct 
      @result = ToggleAnswerCorrect.call params[:id]
      if @result.success?
        @answer = @result.answer
        render json: @answer
      else
        render json: { errors: @result.error }, status: 422
      end
    end
    
    private 
    
    def answer_params
      params.require(:answer).permit(:body, :question_id, :correct, :points)
    end
  end
end