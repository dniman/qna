require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question 
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario 'Unauthenticated user can\'t edit a question' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(user)
      visit questions_path
      
      within '.questions' do
        click_on 'Edit'
      end   
      
      expect(page).to have_content question.title
      expect(page).to have_content question.body
    end

    scenario 'tries to edit other user\'s question' do
      other_user = create(:user)
      sign_in other_user
      visit questions_path

      within '.questions' do
        expect(page).not_to have_button 'Edit'
      end
    end
  end
end
