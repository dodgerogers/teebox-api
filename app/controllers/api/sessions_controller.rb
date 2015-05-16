module Api
  class SessionsController < ApplicationController
    
    skip_before_action :authenticate_user!, [:create]
    acts_as_token_authentication_handler_for User, except: [:create]
     
    respond_to :json
 
    def create
      result = CreateUserSession.call params
      if result.success?
        render json: result.user, serializer: UserTokenSerializer
      else
        render json: { errors: result.message }, status: result.status
      end
    end
 
    def destroy
      if current_user
        current_user.invalidate_token!
        render json: { message: "Signed out successfully" }, status: 200
      else
        render json: { errors: 'You are not signed in' }, status: 404
      end
    end
  end
end