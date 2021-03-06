module Api
  class TagsController < ApplicationController
    
    before_action :authenticate_user!, only: [:create, :update, :destroy]
    load_and_authorize_resource only: [:create, :update, :destroy]
  
    def show
      @tag = Tag.find(params[:id])
      render json: @tag
    end
  
    def index
      # Need a repo search by method
      @tags = Tag.order("name")
      @tags = @tags.search(params[:search]) if params[:search]
      @tags = @tags.paginate(page: params[:page], per_page: params[:per_page] || Tag.count)
      render json: @tags
    end
  
    def create
      @tag = current_user.tags.build tag_params
      if @tag.save
        render json: @tag
      else
        render json: { errors: @tag.errors.full_messages }, status: 422
      end
    end
  
    def update
      @tag = Tag.find params[:id]
      if @tag.update_attributes tag_params
        render json: @tag
      else
        render json: { errors: @tag.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @tag = Tag.find params[:id]
      if @tag.destroy
        render json: {}, status: 200
      else
        render json: { errors: @tag.errors.full_messages }, status: 422
      end
    end
  
    def question_tags
      # Add this to the search by repo method
      @tags = Tag.order(:name)
      render json: @tags.tokens(params[:q])
    end
    
    private 
    
    def tag_params
      defaults = { updated_by: current_user.try(:username), user_id: current_user.try(:id) }
      params.require(:tag).permit(:name, :explanation, :updated_by, :user_id).merge(defaults)
    end
  end
end