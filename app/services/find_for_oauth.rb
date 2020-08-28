class Services::FindForOauth
  attr_reader :auth

  def initialize(auth)
    @auth = auth
  end

  def call
    oauth_provider = OauthProvider.where(provider: auth.provider, uid: auth.uid.to_s).first
    return oauth_provider.user if oauth_provider

    email = auth.info[:email]
    user = User.where(email: email).first

    unless user
      password = Devise.friendly_token[0,20]
      user = User.create!(email: email, password: password, password_confirmation: password)
    end
    
    user.oauth_providers.create(provider: auth.provider, uid: auth.uid)
    user
  end
end
