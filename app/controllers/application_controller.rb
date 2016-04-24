class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def authenticate_control!
    user = current_user
    redirect_to root_path if user.nil?

    unless user.control?
      redirect_to root_path
    end
  end

  def authenticate_super_admin!
    user = current_user
    redirect_to root_path if user.nil?

    unless (user.super_admin?)
      redirect_to root_path
    end
  end

  def authenticate_admin!
    user = current_user
    redirect_to root_path if user.nil?
    unless (user.admin?)
      if user.control?
        redirect_to admin_control_path
      else
        redirect_to root_path
      end
    end
  end

  # This needs to be fixed if user is not logged in
  def current_game
    if current_user.nil?
      #Show the last game being run?
      @game = Game.last
    else
      @game = current_user.game
    end
  end
end
