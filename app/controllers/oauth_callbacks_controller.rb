class OauthCallbacksController < Devise::OmniauthCallbacksController
  
  def github
    @user = User.find_for_oauth(request.env["omniauth.auth"])

    if @user&.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
    else
      redirect_to root_path, alert: 'Something went wrong'
    end
  end

  def vkontakte
    auth = request.env["omniauth.auth"]
    @user = User.find_for_oauth(auth)
    
    if @user&.persisted?
      if @user.confirmed?
        sign_in_and_redirect @user, event: :authentication
        set_flash_message(:notice, :success, kind: 'Vkontakte') if is_navigational_format?
      else
        redirect_to new_user_confirmation_path
      end
    else
      session["devise.omniauth_data"] = request.env["omniauth.auth"].except("extra")
      @enter_email = EnterEmail.new
      render 'vkontakte'
    end
    
  end

end
