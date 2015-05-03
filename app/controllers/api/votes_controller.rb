module Api
  class VotesController < ApplicationController
    load_and_authorize_resource
  
    def create
      @vote = current_user.votes.build vote_params
      if @vote.save
        # TODO: Point repo should just accept a vote object
        PointRepository.create @vote.votable.user, @vote, @vote.points
        render json: @vote
      else
        render json: { errors: @vote.errors.full_messages }, status: 422
      end
    end
    
    private
    
    def vote_params
      params.require(:vote).permit(:value, :votable_id, :votable_type, :points)
    end
  end
end