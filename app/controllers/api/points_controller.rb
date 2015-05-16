module Api
  class PointsController < ApplicationController
    
    before_action :authenticate_user!
    load_and_authorize_resource except: [:index, :breakdown]
    
    def index
      @points = current_user.points.paginate(page: params[:page], per_page: 12)
      render json: @points, status: 200
    end
  
    # Should be moved into the index method with a repo method
    def breakdown
      @points = current_user.points.limit(5)
      render json: @points, status: 200
    end
  end
end