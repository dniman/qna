require 'rails_helper'

feature 'User can sign in', %q{
  In order to ask questions
  As an unathenticated user
  I'd like to be able to sign in
} do

  given(:user) { create(:user) }

  scenario 'Registered user tries to sign in' do
    sign_in(user)

    expect(page).to have_content 'Signed in successfully.'
    expect(page).to have_content 'Sign out'
  end

  scenario 'Unregistered user tries to sign in' do
    visit new_user_session_path
    
    fill_in 'user_email', with: 'wrong@test.com'
    fill_in 'user_password', with: '12345678'
    click_on 'Log in'

    expect(page).to have_content 'Invalid Email or password.'
  end

end
