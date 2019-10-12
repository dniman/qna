require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to find question of interest
  As an user
  I'd like to be able to see a list of questions
} do

  given!(:questions) { create_list(:question, 2) }

  scenario 'Authentication user can view a list of questions' do
    user = create(:user)
    sign_in(user)

    visit questions_path

    expect(page).to have_content(/MyString \d/).twice 
  end

  scenario 'Unauthenticated user can view a list of questions' do
    visit questions_path

    expect(page).to have_content(/MyString \d/).twice 
  end
end
