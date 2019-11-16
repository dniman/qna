require 'rails_helper'

feature 'User can delete his answer', %q{
  As a user
  I'd like to be able to delete my answers
} do
  
  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question_id: question.id, user_id: user.id) }

  describe 'Authenticated user' do
    scenario 'can delete his answer', js: true do
      sign_in user
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
      other_user = create(:user)
      sign_in other_user
      visit question_path(question)

      within '.answers' do
        expect(page).not_to have_button 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user can\'t delete an answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Delete'
  end
end
