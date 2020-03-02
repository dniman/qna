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

    expect(page).not_to have_link 'Vote yes'
    expect(page).not_to have_link 'Vote no'
  end
  
  describe 'Authenticated user', js: true do
    before(:each) do 
      sign_in(user) 
      visit questions_path
    end
    
    context 'as not an author of question' do
      scenario 'can vote for the liked question' do
        within ".questions" do
          within ".row-question-#{questions.first.id}" do
            expect(page).to have_link('Vote yes')

            click_on 'Vote yes'

            expect(page).to have_link('Cancel vote')

            within ".vote-rating" do
              expect(page).to have_content('1')
            end
          end 
        end
      end
      
      scenario 'can vote for the unliked question' do
        within ".questions" do
          within ".row-question-#{questions.first.id}" do
            expect(page).to have_link('Vote no')
            
            click_on 'Vote no'

            expect(page).to have_link('Cancel vote')
            
            within ".vote-rating" do
              expect(page).to have_content('-1')
            end
          end
        end
      end

      scenario 'can cancel the voted question' do
        within ".questions" do
          within ".row-question-#{questions.first.id}" do
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

    context 'as an author of question' do
      scenario 'can\'t vote for his question' do
        within ".questions" do
          within ".row-question-#{questions.last.id}" do
            expect(page).not_to have_link('Vote yes')
            expect(page).not_to have_link('Vote no')
          end 
        end
      end
    end
  end
end
