class Users::SessionsController < Devise::SessionsController
  respond_to :html, :js

  def create
    if request.xhr?
      return  root_path #sign_in_and_render resource_name, warden.authenticate!(:scope => resource_name, :recall => "users/sessions#failure")
    else
      super
    end
  end
  
  def sign_in_and_render resource_or_scope, resource = nil
    scope = Devise::Mapping.find_scope! resource_or_scope
    resource ||= resource_or_scope
    sign_in(scope, resource) unless warden.user(scope) == resource
    return render "create"
  end
 
  def failure
    return render "failure"
  end
end