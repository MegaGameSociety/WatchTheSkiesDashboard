class SplashController < ApplicationController
  helper_method :resource_name, :resource, :devise_mapping
  layout "logged_out_layout"

  def resource_name
    :user
  end
 
  def resource
    @resource ||= User.new
  end
 
  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def index
  end
end
