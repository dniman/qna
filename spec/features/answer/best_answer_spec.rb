require 'rails_helper'

feature 'User can mark the best answer', %q{
  In order to show suitable solution 
  As an author of question
  I'd like to be able to choose the best answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question) }

  scenario 'Unauthenticated user can\'t mark the best answer' do
    visit question_path(question)

    expect(page).not_to have_link 'Mark as the best answer'
  end

  describe 'Authenticated user' do
    scenario 'can mark the best answer to his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      within '.answers' do
        click_on 'Mark as the best answer'

        expect(page).to have_selector('.best-answer')
        expect(page).to have_content('Best answer')  
      end
    end

    scenario 'can change the best answer to his question', js: true do
      new_answer = create(:answer, question: question) 

      sign_in(question.user)

      visit question_path(question)
      
      within '.answers' do
        within ".row-answer-#{answer.id}" do
          click_on 'Mark as the best answer'
        end 

        within ".row-answer-#{new_answer.id}" do
          click_on 'Mark as the best answer'
          expect(page).to have_content('Best answer')
        end

        within ".row-answer-#{answer.id}" do
          expect(page).to have_link('Mark as the best answer')
        end
      end
    end

    scenario 'tries to mark the best answer to other user\'s question', js: true do
      new_answer = create(:answer, question: question, user: user)
      sign_in(user)
      visit question_path(question)

      within '.answers' do
        within ".row-answer-#{new_answer.id}" do
          expect(page).not_to have_link('Mark as the best answer')
        end 
      end
    end
  end
end
