require 'rails_helper'

feature 'User can sign up', %q{
  In order to become registered user
  As a guest
  I'd like to be able to sign up
} do

  scenario 'Unregistered user tries to sign up' do
    visit new_user_registration_path
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '12345678'
    fill_in 'Password confirmation', with: '12345678'
    click_on 'Sign up'

    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end
end
