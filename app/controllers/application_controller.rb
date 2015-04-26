class ApplicationController < ActionController::API

  after_filter :store_location
  helper_method :resource_name, :resource, :devise_mapping
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_path, alert: exception.message
  end
  
  def store_location
    session[:previous_url] = request.fullpath unless request.fullpath =~ /\/users/
  end
  
  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end
end
