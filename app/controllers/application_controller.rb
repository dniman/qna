class ApplicationController < ActionController::Base

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  check_authorization :unless => :do_not_check_authorization?

  def do_not_check_authorization?
    respond_to?(:devise_controller?) or
    respond_to?(:users_controller?)
  end
end
