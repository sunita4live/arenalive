class Users::RegistrationsController < Devise::RegistrationsController
  respond_to :html, :js
  
  before_filter :configure_permitted_parameters
  

  def create
    super
  end

  protected
  

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) do |u|
      u.permit(:first_name, :email, :password, :password_confirmation, :provider, :uid, :oauth_token, :oauth_expires_at, :role, :confirmed_at, :confirmation_token)
    end
    
    devise_parameter_sanitizer.for(:account_update) do |u|
      u.permit(:first_name, :last_name, :email, :password, :password_confirmation, :current_password, :mobile, :age, :avatar, :city, :address, :provider, :uid, :oauth_token, :oauth_expires_at, :role, :confirmed_at, :confirmation_token)
    end
  end

  def after_sign_up_path_for(resource)
    flash[:notice] = 'Welcome! You have signed up successfully.'
    root_path
  end 

  def update_resource(resource, params)
    resource.update_without_password(params)
  end

  def after_update_path_for resource
    flash[:notice] = 'You are successfully updated information'
    edit_user_registration_path
  end
end