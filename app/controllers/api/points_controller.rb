module Api
  class PointsController < ApplicationController
    load_and_authorize_resource except: [:index, :breakdown]
    
    def index
      @points = current_user.points.paginate(page: params[:page], per_page: 12)
      render json: @points, status: 200
    end
  
    def breakdown
      @points = current_user.points.limit(5)
      render json: @points, status: 200
    end
  end
end