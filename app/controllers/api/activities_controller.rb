module Api
  class ActivitiesController < ApplicationController
    include ActivityHelper
    load_and_authorize_resource
    
    def index
      repo = ActivityRepository.new current_user
      result = repo.find_all
      
      if result.success?
        render json: result.collection
      else
        render json: { errors: result.errors[:message] }, status: 422
      end
    end
  
    def read
      repo = ActivityRepository.new current_user
      result = repo.find_and_update activity_params.merge(read: true)
      
      if result.success?
        render json: result.entity
      else
        render json: { errors: result.errors[:message] }, status: 422
      end
    end
    
    private
    
    def activity_params
      params.permit(:id)
    end
  end
end