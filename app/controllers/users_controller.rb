class UsersController < ApplicationController
  skip_authorization_check only: :enter_email

  def enter_email
    @enter_email = EnterEmail.new(enter_email_params)
    
    if @enter_email.valid?
      auth = OmniAuth::AuthHash.new(session["devise.omniauth_data"])
      @user = User.find_for_oauth(auth, enter_email_params[:email])
      
      if @user&.persisted? 
        if @user.confirmed?
          sign_in_and_redirect @user, event: :authentication
        else
          redirect_to new_user_confirmation_path
        end
      else
        redirect_to new_user_registration_path
      end
    else
      render @enter_email
    end
  end

  private

    def enter_email_params
      params[:enter_email].permit(:email)
    end
end
