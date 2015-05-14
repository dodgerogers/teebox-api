module Api
  class RegistrationsController < Devise::RegistrationsController
    
    skip_before_action :authenticate_user!
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
          render json: resource, message: "signed_up_but_#{resource.inactive_message}" 
        end
      else
        clean_up_passwords resource
        set_minimum_password_length
        render json: resource
      end
    end
    
    # PUT /users
    # def update
    #       self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    #       prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)
    #       
    #       resource_updated = update_resource resource, account_update_params
    #       if resource_updated
    #         flash_key = update_needs_confirmation?(resource, prev_unconfirmed_email) ? :update_needs_confirmation : :updated
    #         set_flash_message :notice, flash_key
    #         
    #         sign_in resource_name, resource, bypass: true
    #         render json: resource, serializer: UserTokenSerializer
    #       else
    #         clean_up_passwords resource
    #         render json: { errors: resource.errors.full_messages }
    #       end
    #     end
    
    # DELETE /users/:id
    # def destroy
    #       resource.destroy
    #       Devise.sign_out_all_scopes ? sign_out : sign_out(resource_name)
    #       #set_flash_message :notice, :destroyed if is_flashing_format?
    #       yield resource if block_given?
    #       #respond_with_navigational(resource){ redirect_to after_sign_out_path_for(resource_name) }
    #     end

    def signup_sanitized_params
      params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
  end
end