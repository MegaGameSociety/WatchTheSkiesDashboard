class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_control!
    unless current_user.control?
      redirect_to root_path
    end
  end

  def authenticate_super_admin!
    unless (current_user.super_admin?)
      redirect_to root_path
    end
  end

  def authenticate_admin!
    unless (current_user.admin?)
      if current_user.control?
        redirect_to admin_control_path
      else
        redirect_to root_path
      end
    end
  end
end
