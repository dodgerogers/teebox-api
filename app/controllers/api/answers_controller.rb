module Api
  class AnswersController < ApplicationController
  
    # before_filter :authenticate_user!, except: [:show]
    #   load_and_authorize_resource
    require 'teebox/commentable'
    include Teebox::Commentable
  
    def show
      @answer = Answer.find params[:id]
      render json: @answer
    end
  
    def create
      # @answer = current_user.answers.build params[:answer]
      @answer = Answer.new params[:answer]
      respond_to do |format|
        if @answer.save
          PointRepository.create @answer.user, @answer
          repo = ActivityRepository.new(@answer)
          repo.generate :create, owner: current_user, recipient: @answer.question.user
          render json: @answer
        else
          render json: { message: @answer.errors.full_messages }, status: 422
        end
      end
    end
  
    def update
      @answer = Answer.find(params[:id])
      if @answer.update_attributes(params[:answer])
          render json: @answer
      else
        render json: { message: @answer.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @answer = Answer.find(params[:id])
      if @answer.destroy
         render json: {}, status: 200
      else
        render json: { message: @answer.errors.full_messages }, status: 422
      end
    end
  
    def correct 
      @result = ToggleAnswerCorrect.call(params) 
      if @result.success?
        @answer = @result.answer
        render json: @answer
      else
        render json: { message: @answer.errors.full_messages }, status: 422
      end
    end
  end
end