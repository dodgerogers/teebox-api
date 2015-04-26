module Api
  class ErrorsController < ApplicationController
    def show
      @exception = env["action_dispatch.exception"]
      render json: { status: request.path[1..-1], error: @exception.message }
    end
  end
end