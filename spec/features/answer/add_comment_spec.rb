require 'rails_helper'

feature 'User can add comments to answer', %q{
  In order to discuss about answer
  As an authenticated user 
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given(:answer) { create(:answer) }
  
  context 'Authenticated user adds comment to the answer', js: true do
    before do
      sign_in(user)
      visit question_path(answer.question)

      within '.question-answers' do
        within ".row-answer-#{ answer.id }" do
          click_link 'Comments'
        end
      end
    end

    scenario 'with valid attibutes' do
      within ".row-answer-#{ answer.id }" do
        within '.new-comment', visible: true do
          fill_in 'Your Comment', with: 'answer comment'
          click_on 'Add comment'
        end 
      end
      
      within ".row-answer-#{ answer.id }" do
        within '.answer-comments' do
          expect(page).to have_content('answer comment')
        end
      end
    end

    context 'with invalid attributes' do
      scenario 'when body is empty' do
        within ".row-answer-#{ answer.id }" do
          within '.new-comment' do
            click_on 'Add comment'
          end

          within '.comment-errors' do        
            expect(page).to have_content("Body can't be blank")
          end
        end
      end
    end
    
    context 'multiple sessions' do
      scenario "comment appears on another user's question page", js: true do
        Capybara.using_session('user') do
          sign_in(answer.user)
          visit question_path(answer.question)

          within ".row-answer-#{ answer.id }" do
            click_link 'Comments'
          end
        end

        Capybara.using_session('another_user') do
          sign_in(user)
          visit question_path(answer.question)

          within ".row-answer-#{ answer.id }" do
            click_link 'Comments'
          end
        end
       
        Capybara.using_session('user') do
          within ".row-answer-#{ answer.id }" do
            within '.new-comment' do
              fill_in 'Comment', with: 'new comment'
              click_on 'Add comment'
            end

            within '.answer-comments' do
              expect(page).to have_content 'new comment'
            end
          end
        end

        Capybara.using_session('another_user') do
          within ".row-answer-#{ answer.id }" do
            within '.answer-comments' do
              expect(page).to have_content 'new comment'
            end
          end
        end
      end
    end
  end
end
