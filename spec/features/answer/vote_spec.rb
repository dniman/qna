require 'rails_helper' 

feature 'User can vote for the answer', %q{
  In order to rate an answer  
  As an authenticated user
  I'd like to be able to vote for the answer 
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answers) { [ create(:answer, question: question), create(:answer, question: question, user: user) ] }

  scenario 'Unauthenticated user can\'t vote for the answer' do
    visit question_path(question)

    within ".question-answers" do
      within ".vote-actions-#{ answers.first.id }" do
        expect(page).to have_css('.button-disabled').twice
        expect(page).to have_no_css("form[action='/answers/#{answers.first.id}/vote_yes']")
        expect(page).to have_no_css("form[action='/answers/#{answers.first.id}/vote_no']")
        expect(page).to have_no_css("form[action='/answers/#{answers.first.id}/cancel_vote']")
      end
    end
  end
  
  describe 'Authenticated user', js: true do
    before(:each) do 
      sign_in(user) 
      visit question_path(question)
    end
    
    context 'as not an author of answer' do
      scenario 'can vote for the liked answer' do
        within ".question-answers" do
          within ".vote-actions-#{answers.first.id}" do
            within "form[action='/answers/#{answers.first.id}/vote_yes']" do
              expect(page).to have_css('.button.button-unset')
            end

            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            within "form[action='/answers/#{answers.first.id}/vote_no']" do
              expect(page).to have_css('.button.button-unset')
            end

            within "form[action='/answers/#{answers.first.id}/vote_yes']" do
              find('.button.button-unset').click
            end
          end 

          within ".vote-actions-#{answers.first.id}" do
            expect(page).to have_css("form[action='/answers/#{answers.first.id}/cancel_vote']")
            
            within ".vote-rating" do
              expect(page).to have_content('1')
            end
            
            expect(page).to have_css('.button-disabled')
          end 
        end
      end
      
      scenario 'can vote for the unliked answer' do
        within ".question-answers" do
          within ".vote-actions-#{answers.first.id}" do
            within "form[action='/answers/#{answers.first.id}/vote_yes']" do
              expect(page).to have_css('.button.button-unset')
            end

            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            within "form[action='/answers/#{answers.first.id}/vote_no']" do
              expect(page).to have_css('.button.button-unset')
            end

            within "form[action='/answers/#{answers.first.id}/vote_no']" do
              find('.button.button-unset').click
            end
          end 

          within ".vote-actions-#{answers.first.id}" do
            expect(page).to have_css('.button-disabled')
            
            within ".vote-rating" do
              expect(page).to have_content('-1')
            end
            
            expect(page).to have_css("form[action='/answers/#{answers.first.id}/cancel_vote']")
          end 
        end
      end

      scenario 'can cancel the voted answer' do
        within ".question-answers" do
          within ".vote-actions-#{answers.first.id}" do
            within "form[action='/answers/#{answers.first.id}/vote_no']" do
              find('.button.button-unset').click
            end
            
            within "form[action='/answers/#{answers.first.id}/cancel_vote']" do
              find('.button.button-set').click
            end
          end 

          within ".vote-actions-#{answers.first.id}" do
            expect(page).to have_css('.button.button-unset').twice
            
            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            expect(page).to have_css("form[action='/answers/#{answers.first.id}/vote_yes']")
            expect(page).to have_css("form[action='/answers/#{answers.first.id}/vote_no']")
          end 
        end
      end
    end

    context 'as an author of answer' do
      scenario 'can\'t vote for his answer' do
        within ".vote-actions-#{ answers.last.id }" do
          expect(page).to have_css('.button-disabled').twice
          expect(page).to have_no_css("form[action='/answers/#{answers.last.id}/vote_yes']")
          expect(page).to have_no_css("form[action='/answers/#{answers.last.id}/vote_no']")
          expect(page).to have_no_css("form[action='/answers/#{answers.last.id}/cancel_vote']")
        end
      end
    end
  end
end
