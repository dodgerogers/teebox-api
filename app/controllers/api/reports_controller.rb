module Api
  class ReportsController < ApplicationController
    load_and_authorize_resource
    
    def index
      @reports = Report.order("created_at")
      render json: @reports
    end
  
    def create
      # TODO This is weird, create an instance in the repo
      @report = Report.new
      success = ReportRepository.generate @report
      if success
        render json: @report, status: 200
      else
        render json: { errors: @report.errors.full_messages }, status: 422
      end
    end 
  
    def destroy
      @report = Report.find(params[:id])
      if @report.destroy
        render json: @report, status: 200
      else
        render json: { errors: @report.errors.full_messages }, status: 422
      end
    end
  end
end