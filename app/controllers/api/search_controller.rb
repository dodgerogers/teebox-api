module Api
  class SearchController < ApplicationController
    def index
      @result = GlobalSearch.call params
      if @result.success?
        render json: { collection: @result.collection, total: @result.total }, status: 200
      else
        render json: { message: @result.message }, status: 422
      end
    end
  end
end