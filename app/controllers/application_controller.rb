class ApplicationController < ActionController::Base
  include Response
  include ExceptionHandler
  include CheckAuthorization
end
