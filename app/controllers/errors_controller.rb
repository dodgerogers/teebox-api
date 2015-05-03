class ErrorsController < ApplicationController
  def show
    @exception = env["action_dispatch.exception"]
    render json: { errors: @exception.message }, status: request.path[1..-1]
  end
end