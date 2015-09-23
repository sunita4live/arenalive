class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  
  #check_authorization
  #load_and_authorize_resource
  
  protect_from_forgery with: :exception
  skip_before_filter :verify_authenticity_token
  #before_action :authenticate_user!
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to '/', :alert => exception.message
  end
  #before_action :configure_permitted_parameters, if: :devise_controller?
  protected

  def after_sign_in_path_for(resource)
    
    if current_user.has_role? :admin
      flash.now[:notice] = 'Signed in as Admin'
      edit_user_registration_path
    elsif current_user.has_role? :ground_owner
      flash.now[:notice] = 'Signed in as ground_owner'
      edit_user_registration_path
    else
      flash[:notice] = 'Signed in as member'
      root_path
    end
  end
end
