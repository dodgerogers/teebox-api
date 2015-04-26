module Api
  class CommentsController < ApplicationController
  
    # before_filter :authenticate_user!, except: [:index]
    #   before_filter :load_commentable
    #   load_and_authorize_resource except: [:new]
  
    def show
      @comment = Comment.find params[:id]
      render json: @comment
    end
  
    def index
      @comments = @commentable.comments.includes(:user, :commentable)#.paginate(page: params[:page], per_page: 3)
      respond_to do |format|
        format.html { render layout: false }
      end
    end
  
    def create 
      @comment = @commentable.comments.build(params[:comment])
      @comment.user_id = current_user.id
      respond_to do |format|
      if @comment.save
        repo = ActivityRepository.new(@comment)
        repo.generate(:create, owner: current_user, recipient: @commentable.user)
        format.html { redirect_to :back, notice: 'Comment created'}
        format.js
      else
        format.html { redirect_to :back, notice: "Content can't be blank" }
        format.js
        end
      end
    end
  
    def destroy
      @comment = Comment.destroy(params[:id])
      respond_to do |format|
        format.js
      end
    end
  
    private
  
    def load_commentable
      resource, id = request.path.split('/')[1,2]
      @commentable = resource.singularize.classify.constantize.find(id)
    end
  end
end