module Api
  class VideosController < ApplicationController
  
    # before_filter :authenticate_user!
    #   load_and_authorize_resource
  
    def show
      @video = Video.find params[:id]
      render json: @video
    end
  
    def index
      @videos = current_user.videos
      render json: @videos
    end
  
    def new   
    end
  
    def create
      # ====== Should be in interactor ======
      @video = current_user.videos.build(params[:video])
      if @video.save
        TranscoderRepository.generate(@video)
        render json: @video, status: :created, location: @video
      else
        render json: @video.errors, status: 422
      end
    end
  
    def update
      respond_to do |format|
        if @video.update_attributes(video_params)
          format.html { redirect_to @video, notice: "Video updated successfully" }
          format.js
        else
          format.html { render :edit; flash[:error] = "Something went wrong. Plese try again." }
          format.js
        end
      end
    end
  
    def destroy
      # ======= Should be in an interactor ====== #
      @video = Video.destroy(params[:id])
      if @video.destroy
        @video.delete_aws_key
        respond_to do |format|
          format.html { redirect_to videos_path, notice: "Video deleted" }
          format.js
        end
      end
    end
  
    private 
  
    def video_params
      params[:video].slice(:name, :location)
    end
  end
end