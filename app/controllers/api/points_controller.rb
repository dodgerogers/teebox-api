module Api
  class PointsController < ApplicationController
  
    # before_filter :set_points
    #   load_and_authorize_resource except: [:breakdown]
  
    def index
      @points = @load_points.paginate(page: params[:page], per_page: 12)
    end
  
    def breakdown
      @points = @load_points.limit(5)
      render partial: "points/get_points", locals: { points: @points }
    end
  
    private
  
    def set_points
      @user = User.find(params[:id])
      @load_points = Point.find_points(@user)
    end
  end
end