module Api
  class VideosController < ApplicationController
    load_and_authorize_resource
  
    def show
      @video = Video.find params[:id]
      render json: @video
    end
  
    def index
      @videos = current_user.videos
      render json: @videos
    end
  
    def create
      # ====== Should be in interactor ======
      @video = current_user.videos.build video_params
      if @video.save
        TranscoderRepository.generate(@video)
        render json: @video
      else
        render json: { errors: @video.errors }, status: 422
      end
    end
  
    def update
      @video = Video.find params[:id]
      if @video.update_attributes video_params
         render json: @video
      else
        render json: { errors: @video.errors }, status: 422
      end
    end
  
    def destroy
      # ======= Should be in an repo ====== #
      @video = Video.find params[:id]
      if @video.destroy
        @video.delete_aws_key
        render json: {}, status: 200
      else
        render json: { errors: @video.errors.full_messages }, status: 422
      end
    end
  
    private 
  
    def video_params
      params.require(:video).permit(:file, :screenshot, :job_id, :status, :name, :duration, :location)
    end
  end
end