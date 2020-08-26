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

    within ".question-answers" do
      within ".best-answer-action-#{answer.id}" do
        expect(page).to have_css('.button-disabled')
        expect(page).to have_no_css("form[action='/answers/#{answer.id}/mark_as_the_best']")
      end
    end
  end

  describe 'Authenticated user' do
    scenario 'can mark the best answer to his question', js: true do
      sign_in(question.user)
      visit question_path(question)

      within '.question-answers' do
        within ".best-answer-action-#{answer.id}" do
          within "form[action='/answers/#{answer.id}/mark_as_the_best']" do
            expect(page).to have_css('.button.button-unset')
            find('.button.button-unset').click
          end
        end

        within ".best-answer-action-#{answer.id}" do
          expect(page).to have_css('.button-set.button-disabled')
          expect(page).to have_no_css("form[action='/answers/#{answer.id}/mark_as_the_best']")
        end
      end
    end

    scenario 'can change the best answer to his question', js: true do
      new_answer = create(:answer, question: question) 
      sign_in(question.user)
      visit question_path(question)
      
      within '.question-answers' do
        within ".best-answer-action-#{answer.id}" do
          within "form[action='/answers/#{answer.id}/mark_as_the_best']" do
            find('.button.button-unset').click
          end
        end

        within ".best-answer-action-#{new_answer.id}" do
          within "form[action='/answers/#{new_answer.id}/mark_as_the_best']" do
            find('.button.button-unset').click
          end
        end
        
        within ".best-answer-action-#{answer.id}" do
          expect(page).to have_css("form[action='/answers/#{answer.id}/mark_as_the_best']")
        end
        
        within ".best-answer-action-#{new_answer.id}" do
          expect(page).to have_css('.button-set.button-disabled')
        end
      end
    end

    scenario 'tries to mark the best answer to other user\'s question', js: true do
      new_answer = create(:answer, question: question, user: user)
      sign_in(user)
      visit question_path(question)

      within ".question-answers" do
        within ".best-answer-action-#{new_answer.id}" do
          expect(page).to have_css('.button-disabled')
          expect(page).to have_no_css("form[action='/answers/#{new_answer.id}/mark_as_the_best']")
        end
      end
    end
  end
end
