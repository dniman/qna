require 'rails_helper'

feature 'User can delete his answer', %q{
  As a user
  I'd like to be able to delete my answers
} do
  
  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answer) { create(:answer, question: question, user: users[0]) }

  describe 'Authenticated user' do
    scenario 'can delete his answer', js: true do
      sign_in(users[0])
      visit question_path(question)

      within '.answers' do
        expect(page).to have_content answer.body
      end

      page.accept_confirm do
        click_link 'Delete'
      end
      
      within '.answers' do
        expect(page).not_to have_content answer.body
      end
    end

    scenario 'can\'t delete other user\'s answer' do
      sign_in(users[1]) 
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user can\'t delete an answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
