module FeatureHelpers
  def sign_in(user)
    visit new_user_session_path
   
    fill_in 'user_email', with: user.email
    fill_in 'user_password', with: user.password
    click_on 'Log in'
  end

  def sign_out
    click_on "Sign out"
  end

  def sign_in_with_github(email)
    visit new_user_session_path

    OmniAuth.config.test_mode = true
    OmniAuth.config.mock_auth[:github] = OmniAuth::AuthHash.new({
      'provider' => 'github',
      'uid' => '123456',
      'info' => {
        'email' => "#{ email }"
      }
    })
    
    click_on 'Sign in with GitHub'
  end
end
