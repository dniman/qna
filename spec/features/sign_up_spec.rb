require 'rails_helper'

feature 'User can sign up', %q{
  In order to become registered user
  As a guest
  I'd like to be able to sign up
} do

  describe 'Unregistered user tries to sign up' do
    scenario 'successfully' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@test.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '12345678'
      click_on 'Sign up'
      
      expect(page).to have_content('A message with a confirmation link has been sent to your email address. Please follow the link to activate your account.')

      open_email('user@test.com')
      current_email.click_link 'Confirm my account'

      expect(page).to have_content('Your email address has been successfully confirmed.')
    end

    scenario 'with 1 error' do
      visit new_user_registration_path
      fill_in 'user_email', with: 'user@test.com'
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '1234567'
      click_on 'Sign up'

      expect(page).to have_content '1 error prohibited this user from being saved:'
    end

    scenario 'with more errors' do
      visit new_user_registration_path
      fill_in 'user_email', with: ''
      fill_in 'user_password', with: '12345678'
      fill_in 'user_password_confirmation', with: '1234567'
      click_on 'Sign up'

      expect(page).to have_content /\d+ errors prohibited this user from being saved:/
    end
  end
end
