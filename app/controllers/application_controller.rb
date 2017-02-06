class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :readable_datetime

  def readable_datetime(dt)
    dt.strftime("%Y-%m-%d %H:%M") if dt
  end


  before_filter :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:name, :email, :current_password) }
    devise_parameter_sanitizer.for(:account_update) { |u| u.permit(:name, :email, :current_password) }
  end
end
