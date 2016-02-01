class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_role!
    unless User::CONTROL_ROLES.include?(current_user.role)
      redirect_to root_path
    end
  end
end
