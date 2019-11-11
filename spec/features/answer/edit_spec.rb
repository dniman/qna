require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can\'t edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      click_on 'Edit'
      
      within '.answers' do
        fill_in 'Body', with: 'edited answer'
        click_on 'Save your answer'
        
        expect(page).not_to have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)
      
      click_on 'Edit'

      within '.answers' do
        fill_in 'Body', with: ''
        click_on 'Save your answer'
        
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
    
    scenario 'tries to edit other user\'s answer' do
      other_user = create(:user)
      sign_in other_user
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_button 'Edit'
      end
    end
  end
end
