class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include CheckAuthorization

  check_authorization :unless => :do_not_check_authorization?

  def do_not_check_authorization?
    respond_to?(:devise_controller?) or
    respond_to?(:users_controller?) or
    respond_to?(:profiles_controller?)
  end
end
