module Api
  class UsersController < ApplicationController
  
    def show
      repo = UserRepository.new current_user
      result = repo.find_by user_params
      
      if result.success?
        render json: result.entity
      else
        render json: { errors: result.errors[:message] }, status: 404
      end  
    end
  
    def index
      repo = UserRepository.new current_user
      result = repo.find_all_by_rank
      
      if result.success?
        render json: result.collection
      else
        render json: { errors: result.errors[:message] }, status: 422
      end
    end
    
    private
    
    def user_params
      params.permit(:id)
    end
  end
end