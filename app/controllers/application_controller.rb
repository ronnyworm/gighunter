class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :readable_datetime

  def readable_datetime(dt)
    dt.strftime("%Y-%m-%d %H:%M")
  end
end
