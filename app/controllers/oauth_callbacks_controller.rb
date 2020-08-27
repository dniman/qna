class OauthCallbacksController < Devise::OmniauthCallbacksController
  def vkontakte
    render json: request.env['omniauth.auth']
  end

end
