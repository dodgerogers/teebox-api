module Api
  class VotesController < ApplicationController
  
    # before_filter :authenticate_user!
  
    def create
      @vote = current_user.votes.build(params[:vote])
        if @vote.save
        PointRepository.create(@vote.votable.user, @vote, @vote.points)
        render json: @vote
      else
        render json: { message: @vote.errors.full_messages }, status: 422
      end
    end
  end
end