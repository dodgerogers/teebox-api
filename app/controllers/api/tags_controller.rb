module Api
  class TagsController < ApplicationController
  
    # before_filter :authenticate_user!, except: :index
    #   load_and_authorize_resource
  
    def new
      @tag = Tag.new
    end
  
    def show
      @tag = Tag.find(params[:id])
    end
  
    def index
      @tag = Tag.new
      @tags = Tag.order("name").paginate(page: params[:page], per_page: 21).text_search(params[:search])
    end
  
    def create
      @tag = Tag.create(params[:tag])
      if @tag.save
        redirect_to tags_path, notice: "Tag created" 
      else
        render :new, notice: "Try again" 
      end
    end
  
    def update
      @tag = Tag.find(params[:id])
      @tag.user_id, @tag.updated_by = current_user.id, current_user.username
      respond_to do |format|
        if @tag.update_attributes(params[:tag])
          format.html {  redirect_to tags_path, notice: "Tag updated" }
          format.json { head :no_content }
        else
          format.html { render :edit, notice: "Try again"  }
          format.json { render json: @tag.errors, status: :unprocessable_entity  }
        end
      end
    end
  
    def edit
      @tag = Tag.find(params[:id])
    end
  
    def destroy
      @tag = Tag.find(params[:id]).destroy
      redirect_to tags_path, notice: "Tag Deleted"
    end
  
    def question_tags
      @tags = Tag.order(:name)
      respond_to do |format|
        format.json { render json: @tags.tokens(params[:q]) }
      end
    end
  end
end