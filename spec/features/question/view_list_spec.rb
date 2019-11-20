require 'rails_helper'

feature 'User can view a list of questions', %q{
  In order to find question of interest
  As an user
  I'd like to be able to see a list of questions
} do

  given!(:users) { create_list(:user, 2) }
  given!(:questions) { create_list(:question, 2, user: users[0]) }

  describe 'Authenticated user' do
    scenario 'as an author can view a list of questions' do
      sign_in(users[0])

      visit questions_path

      expect(page).to have_content(/MyString \d/).twice 
    end

    scenario 'as not the author can view a list of question' do
      sign_in(users[1])

      visit questions_path
      expect(page).to have_content(/MyString \d/).twice
    end
  end

  scenario 'Unauthenticated user can view a list of questions' do
    visit questions_path

    expect(page).to have_content(/MyString \d/).twice 
  end
end
