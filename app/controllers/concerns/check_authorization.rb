module CheckAuthorization
  extend ActiveSupport::Concern

  included do
    check_authorization :unless => :do_not_check_authorization?

    def do_not_check_authorization?
      respond_to?(:devise_controller?) or
      respond_to?(:users_controller?)
    end
  end
end
