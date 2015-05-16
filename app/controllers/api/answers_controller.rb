module Api
  class AnswersController < ApplicationController
    load_and_authorize_resource
    
    def show
      repo = AnswerRepository.new current_user
      result = repo.find_by params.slice :id
      
      if result.success?
        render json: result.entity
      else
        render json: { errors: result.errors[:message] }, status: 404
      end
    end
  
    # TODO: Factory and perhaps interactor for the points and activities
    def create
      @answer = current_user.answers.build answer_params
      if @answer.save
        PointRepository.create @answer.user, @answer
        repo = ActivityFactory.new @answer
        repo.generate :create, owner: current_user, recipient: @answer.question.user
        render json: @answer
      else
        render json: { errors: @answer.errors.full_messages }, status: 422
      end
    end
  
    def update
      repo = AnswerRepository.new current_user
      result = repo.find_and_update answer_params.merge(params.slice(:id))
      
      if result.success?
        render json: result.entity
      else
        render json: { errors: result.errors[:message] }, status: 422
      end
    end
  
    def destroy
      repo = AnswerRepository.new current_user
      result = repo.find_and_destroy params.slice :id
      
      if result.success?
        render json: {}, status: 200
      else
        render json: { errors: result.errors[:message] }, status: 422
      end
    end
  
    def correct 
      toggle_answer_params = params.slice(:id).merge(current_user: current_user)
      result = ToggleAnswerCorrect.call toggle_answer_params
      
      if result.success?
        render json: result.answer
      else
        render json: { errors: result.error }, status: 422
      end
    end
    
    private 
    
    def answer_params
      params.require(:answer).permit(:body, :question_id, :correct, :points)
    end
  end
end