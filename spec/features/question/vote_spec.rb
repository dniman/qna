require 'rails_helper' 

feature 'User can vote for the question', %q{
  In order to rate a question 
  As an authenticated user
  I'd like to be able to vote for the question 
} do

  given!(:user) { create(:user) }
  given!(:questions) { [ create(:question), create(:question, user: user) ] }

  scenario 'Unauthenticated user can\'t vote for the question' do
    visit questions_path

    within ".question-row-#{ questions.first.id }" do
      within ".vote-actions-#{ questions.first.id }" do
        expect(page).to have_css('.button-disabled').twice
        expect(page).to have_no_css("form[action='/questions/#{questions.first.id}/vote_yes']")
        expect(page).to have_no_css("form[action='/questions/#{questions.first.id}/vote_no']")
        expect(page).to have_no_css("form[action='/questions/#{questions.first.id}/cancel_vote']")
      end
    end
  end
  
  describe 'Authenticated user', js: true do
    before(:each) do 
      sign_in(user) 
      visit questions_path
    end
    
    context 'as not an author of question' do
      scenario 'can vote for the liked question' do
        within ".questions" do
          within ".vote-actions-#{questions.first.id}" do
            within "form[action='/questions/#{questions.first.id}/vote_yes']" do
              expect(page).to have_css('.button.button-unset')
            end

            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            within "form[action='/questions/#{questions.first.id}/vote_no']" do
              expect(page).to have_css('.button.button-unset')
            end

            within "form[action='/questions/#{questions.first.id}/vote_yes']" do
              find('.button.button-unset').click
            end
          end 


          within ".vote-actions-#{questions.first.id}" do
            expect(page).to have_css("form[action='/questions/#{questions.first.id}/cancel_vote']")
            
            within ".vote-rating" do
              expect(page).to have_content('1')
            end
            
            expect(page).to have_css('.button-disabled')
          end 
        end
      end
      
      scenario 'can vote for the unliked question' do
        within ".questions" do
          within ".vote-actions-#{questions.first.id}" do
            within "form[action='/questions/#{questions.first.id}/vote_yes']" do
              expect(page).to have_css('.button.button-unset')
            end

            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            within "form[action='/questions/#{questions.first.id}/vote_no']" do
              expect(page).to have_css('.button.button-unset')
            end

            within "form[action='/questions/#{questions.first.id}/vote_no']" do
              find('.button.button-unset').click
            end
          end 

          within ".vote-actions-#{questions.first.id}" do
            expect(page).to have_css('.button-disabled')
            
            within ".vote-rating" do
              expect(page).to have_content('-1')
            end
            
            expect(page).to have_css("form[action='/questions/#{questions.first.id}/cancel_vote']")
          end 
        end
      end

      scenario 'can cancel the voted question' do
        within ".questions" do
          within ".vote-actions-#{questions.first.id}" do
            within "form[action='/questions/#{questions.first.id}/vote_no']" do
              find('.button.button-unset').click
            end
            
            within "form[action='/questions/#{questions.first.id}/cancel_vote']" do
              find('.button.button-set').click
            end
          end 

          within ".vote-actions-#{questions.first.id}" do
            expect(page).to have_css('.button.button-unset').twice
            
            within ".vote-rating" do
              expect(page).to have_content('0')
            end
            
            expect(page).to have_css("form[action='/questions/#{questions.first.id}/vote_yes']")
            expect(page).to have_css("form[action='/questions/#{questions.first.id}/vote_no']")
          end 
        end
      end
    end

    context 'as an author of question' do
      scenario 'can\'t vote for his question' do
        within ".question-row-#{ questions.last.id }" do
          within ".vote-actions-#{ questions.last.id }" do
            expect(page).to have_css('.button-disabled').twice
            expect(page).to have_no_css("form[action='/questions/#{questions.last.id}/vote_yes']")
            expect(page).to have_no_css("form[action='/questions/#{questions.last.id}/vote_no']")
            expect(page).to have_no_css("form[action='/questions/#{questions.last.id}/cancel_vote']")
          end
        end
      end
    end
  end
end
