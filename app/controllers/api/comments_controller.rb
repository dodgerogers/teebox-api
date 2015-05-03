module Api
  class CommentsController < ApplicationController
    load_and_authorize_resource only: [:create, :destroy]
  
    def show
      @comment = Comment.find params[:id]
      render json: @comment
    end
  
    def create 
      @comment = current_user.comments.build comment_params
      if @comment.save
        repo = ActivityRepository.new @comment
        repo.generate :create, owner: current_user, recipient: @comment.commentable.user
        render json: @comment
      else
        render json: { errors: @comment.errors.full_messages }, status: 422
      end
    end
  
    def destroy
      @comment = Comment.find params[:id]
      if @comment.destroy
        render json: {}, status: 200
      else
        render json: { errors: @comment.errors.full_messages }, status: 422
      end
    end
  
    private
    
    def comment_params
      params.require(:comment).permit(:content, :commentable_id, :commentable_type)
    end
  end
end