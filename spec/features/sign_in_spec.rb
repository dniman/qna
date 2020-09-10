require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unathenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  context 'Registered user tries to' do
    scenario 'sign in' do
      sign_in(user)

      expect(page).to have_content 'Signed in successfully.'
      expect(page).to have_content 'Sign out'
    end

    scenario 'sign in with Github' do
      sign_in_with_github(user.email)

      expect(page).to have_content 'Successfully authenticated from Github account.'
      expect(page).to have_content 'Sign out'
    end

    scenario 'sign in with Vkontakte' do
      visit new_user_session_path
      user.oauth_providers.create!(provider: 'vkontakte', uid: '123456')

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
        'provider' => 'vkontakte',
        'uid' => '123456',
        'info' => {}
      })
      
      click_on 'Sign in with Vkontakte'
      
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      expect(page).to have_content 'Sign out'
    end
  end

  context 'Unregistered user tries to' do
    scenario 'sign in' do
      visit new_user_session_path
      
      fill_in 'user_email', with: 'wrong@test.com'
      fill_in 'user_password', with: '12345678'
      click_on 'Log in'

      expect(page).to have_content 'Invalid Email or password.'
    end

    scenario 'sign in with Github' do
      sign_in_with_github('unregistered_user@example.com')

      expect(page).to have_content 'Successfully authenticated from Github account.'
      expect(page).to have_content 'Sign out'
    end
    
    scenario 'sign in with Vkontakte' do
      visit new_user_session_path

      OmniAuth.config.test_mode = true
      OmniAuth.config.mock_auth[:vkontakte] = OmniAuth::AuthHash.new({
        'provider' => 'vkontakte',
        'uid' => '123456',
        'info' => {}
      })
      
      click_on 'Sign in with Vkontakte'

      fill_in 'user_email', with: 'new_user@test.com'
      
      expect(page).to have_content 'Successfully authenticated from Vkontakte account.'
      expect(page).to have_content 'Sign out'
    end
  end
end
