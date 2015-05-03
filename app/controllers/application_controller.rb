class ApplicationController < ActionController::API
  extend SimpleTokenAuthentication::ActsAsTokenAuthenticationHandler
  include ActionController::RespondWith
  include ActionController::StrongParameters
  include CanCan::ControllerAdditions
  
  acts_as_token_authentication_handler_for User, fallback_to_devise: false
  
  before_action :cancan_patch
  helper_method :user_authenticated?
  
  rescue_from CanCan::AccessDenied do |exception|
    render json: { errors: "You are not authorized to access this page" }, status: 403
  end
  
  def user_authenticated?
    unless current_user
      render json: { errors: "You must be logged in to access this content" }, status: 403
    end
  end
  
  def cancan_patch
    resource = controller_name.singularize.to_sym
    method = "#{resource}_params"
    params[resource] &&= send(method) if respond_to?(method, true)
  end
end