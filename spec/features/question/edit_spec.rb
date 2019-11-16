require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question 
  I'd like to be able to edit my question
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }

  scenario 'Unauthenticated user can\'t edit a question' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(users[0])
      visit questions_path
      
      within '.questions' do
        click_on 'Edit'
      end   
      
      expect(page).to have_selector("input[value='#{question.title}']")
      expect(page).to have_selector('textarea', id: 'question_body', exact_text: question.body)
    end

    scenario 'tries to edit other user\'s question' do
      sign_in(users[1])
      visit questions_path

      within '.questions' do
        expect(page).not_to have_link 'Edit'
      end
    end
  end
end
