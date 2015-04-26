module Api
  class ReportsController < ApplicationController
    # before_filter :authenticate_user! 
    #   before_filter :all_reports, except: [:create, :destroy]
    #   load_and_authorize_resource
  
    def index
      @report = Report.new
    end
  
    def stats
    end
  
    def create
      @report = Report.new
      report_generated = ReportRepository.generate(@report)
      if report_generated
        redirect_to reports_path, notice: "Report Created"
      else
        redirect_to reports_path, notice: "Nothing to report"
      end
    end 
  
    def destroy
      @report = Report.destroy(params[:id])
      if @report.destroy
        redirect_to stats_reports_path, notice: "Report deleted"
      end
    end
  
    def all_reports
      @all_reports = Report.order("created_at")
      @reports = Report.order("created_at DESC").paginate(page: params[:page], per_page: 20)
    end
  end
end