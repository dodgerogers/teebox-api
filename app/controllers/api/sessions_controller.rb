module Api
  class SessionsController < ApplicationController
    acts_as_token_authentication_handler_for User, except: [:create]
     
    respond_to :json
 
    def create
      username, password = params.values_at(:username, :password)
      user = User.where(username: username).first
      
      if user && user.valid_password?(password)
        if user.authentication_token.present?
          render json: { message: "You are already signed in" }, status: 200
        else
          user.save!
          render json: { id: user.id, username: user.username, authentication_token: user.authentication_token }, status: 201
        end
      else
        render json: { errors: 'Invalid email or password.' }, status: 401
      end
    end
 
    def destroy
      if current_user
        current_user.update_attributes(authentication_token: nil)
        render json: {}, status: 204
      else
        render json: { errors: 'You are not signed in' }, status: 404
      end
    end
  end
end