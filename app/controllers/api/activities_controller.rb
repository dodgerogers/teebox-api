module Api
  class ActivitiesController < ApplicationController
    include ActivityHelper
    before_action :user_authenticated?
    load_and_authorize_resource
    
    def index
      @activities = current_user.activities.paginate(page: params[:page], per_page: (params[:per_page] || 20))
      render json: @activities
    end
  
    def read
      # Interactor which calls a find by and then read_activity on the result
      @activity = current_user.activities.find params[:id] 
      @activity.read_activity
      if @activity.save
        render json: @activity
      else
        render json: { errors: @activity.errors.full_messages }, status: 422
      end
    end
  end
end