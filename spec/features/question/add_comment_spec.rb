require 'rails_helper'

feature 'User can add comments to question', %q{
  In order to discuss about question
  As an authenticated user 
  I'd like to be able to add comments
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  context 'Authenticated user adds comment to the question', js: true do
    before do
      sign_in(user)
      visit question_path(question)

      click_link 'Comments'
    end

    scenario 'with valid attibutes' do
      within '.new-comment', visible: true do
        fill_in 'Your Comment', with: 'question comment'
        click_on 'Add comment'
      end 
      
      within '.question-comments' do
        expect(page).to have_content('question comment')
      end
    end

    context 'with invalid attributes' do
      scenario 'when body is empty' do
        within '.new-comment' do
          click_on 'Add comment'
        end

        within '.comment-errors' do        
          expect(page).to have_content("Body can't be blank")
        end
      end
    end
    
    context 'multiple sessions' do
      scenario "comment appears on another user's question page", js: true do
        Capybara.using_session('user') do
          sign_in(question.user)
          visit question_path(question)

          click_link 'Comments'
        end

        Capybara.using_session('another_user') do
          sign_in(user)
          visit question_path(question)

          click_link 'Comments'
        end
       
        Capybara.using_session('user') do
          within '.new-comment' do
            fill_in 'Comment', with: 'new comment'
            click_on 'Add comment'
          end

          within '.question-comments' do
            expect(page).to have_content 'new comment'
          end
        end

        Capybara.using_session('another_user') do
          within '.question-comments' do
            expect(page).to have_content 'new comment'
          end
        end
      end
    end
  end
end
