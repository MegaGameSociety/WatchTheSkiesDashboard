class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up).push(:time_zone)
    devise_parameter_sanitizer.for(:account_update).push(:time_zone)
  end

end

