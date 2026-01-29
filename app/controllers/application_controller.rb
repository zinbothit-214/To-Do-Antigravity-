class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  
  include AuthorizationConcern
  
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :set_current_user_department
  
  protected
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :role, :department_id])
    devise_parameter_sanitizer.permit(:account_update, keys: [:name, :role, :department_id])
  end
  
  def set_current_user_department
    @current_department = current_user&.department
  end
end
