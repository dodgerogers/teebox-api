module Api
  class RegistrationsController < Devise::RegistrationsController
    before_filter :signup_sanitized_params, if: :devise_controller?
    
    clear_respond_to
    respond_to :json
    
    def create
      build_resource signup_sanitized_params
      resource.save
      
      if resource.persisted?
        if resource.active_for_authentication?
          sign_up resource_name, resource
          render json: resource
        else
          expire_data_after_sign_in!
          render json: { errors: resource.errors.full_messages }, status: 422
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        render json: resource
      end
    end

    def signup_sanitized_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
end