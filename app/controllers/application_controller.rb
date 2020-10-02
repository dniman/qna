class ApplicationController < ActionController::Base
  include JSONResponse
  include ExceptionHandler
  include CheckAuthorization
end
