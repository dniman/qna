class ApplicationController < ActionController::Base
  rescue_from CanCan::AccessDenied do |exception|
    respond_to do |format|
      format.json { head :forbidden, content_type: 'text/html' }
      format.html { redirect_to root_url, notice: exception.message }
      format.js   { head :forbidden, content_type: 'text/html' }
    end
  end

  check_authorization :unless => :do_not_check_authorization?

  def do_not_check_authorization?
    respond_to?(:devise_controller?) or
    respond_to?(:users_controller?)
  end
end
