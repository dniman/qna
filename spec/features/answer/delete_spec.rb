require 'rails_helper'

feature 'User can delete his answer', %q{
  As a user
  I'd like to be able to delete my answers
} do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  describe 'Authenticated user' do
    scenario 'can delete his answer', js: true do
      sign_in(answer.user)
      visit question_path(question)

      within ".row-answer-#{answer.id}" do
        expect(page).to have_content answer.body
      
        page.accept_confirm do
          click_link 'Delete'
        end
      end
      
      within '.answers' do
        expect(page).not_to have_content answer.body
      end
    end

    scenario 'can\'t delete other user\'s answer' do
      sign_in(user) 
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user can\'t delete an answer' do
    visit question_path(question)

    within '.answers' do
      expect(page).not_to have_link 'Delete'
    end
  end
end
