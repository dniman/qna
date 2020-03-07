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

    within ".answers" do
      expect(page).not_to have_link 'Vote yes'
      expect(page).not_to have_link 'Vote no'
    end
  end
  
  describe 'Authenticated user', js: true do
    before(:each) do 
      sign_in(user) 
      visit question_path(question)
    end
    
    context 'as not an author of answer' do
      scenario 'can vote for the liked answer' do
        within ".answers" do
          within ".row-answer-#{answers.first.id}" do
            expect(page).to have_link('Vote yes')

            click_on 'Vote yes'

            expect(page).to have_link('Cancel vote')

            within ".vote-rating" do
              expect(page).to have_content('1')
            end
          end 
        end
      end
      
      scenario 'can vote for the unliked answer' do
        within ".answers" do
          within ".row-answer-#{answers.first.id}" do
            expect(page).to have_link('Vote no')
            
            click_on 'Vote no'

            expect(page).to have_link('Cancel vote')
            
            within ".vote-rating" do
              expect(page).to have_content('-1')
            end
          end
        end
      end

      scenario 'can cancel the voted answer' do
        within ".answers" do
          within ".row-answer-#{answers.first.id}" do
            click_on 'Vote yes'
            click_on 'Cancel vote'

            expect(page).to have_link('Vote yes')
            expect(page).to have_link('Vote no')
            
            within ".vote-rating" do
              expect(page).to have_content('0')
            end
          end
        end
      end
    end

    context 'as an author of answer' do
      scenario 'can\'t vote for his answer' do
        within ".answers" do
          within ".row-answer-#{answers.last.id}" do
            expect(page).not_to have_link('Vote yes')
            expect(page).not_to have_link('Vote no')
          end 
        end
      end
    end
  end
end
