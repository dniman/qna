require 'rails_helper'

feature 'User can create an answer on a question page', %q{
  In order to answer a question
  As a user
  I'd like to be able to write an answer on a question page
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }

  describe 'Authenticated user' do
    before do 
      sign_in(user)
      visit question_path(question)
    end 

    scenario 'can write the answer', js: true do
      fill_in 'Body', with: 'content answer'
      click_on 'Post your answer'

      expect(current_path).to eq question_path(question)
      within '.answers' do
        expect(page).to have_content /content answer/
      end
    end
    
    context 'multiple sessions' do
      scenario "answer appears on another user's question page", js: true do
        Capybara.using_session('user') do
          sign_in(user)
          visit question_path(question)
        end

        Capybara.using_session('guest') do
          visit question_path(question)
        end
       
        Capybara.using_session('user') do
          fill_in 'Body', with: 'test answer'
          click_on 'Post your answer'

          within '.answers' do
            expect(page).to have_content 'test answer'
          end
        end

        Capybara.using_session('guest') do
          within '.answers' do
            expect(page).to have_content 'test answer'
          end
        end
      end
    end

    scenario 'create answer with errors', js: true do
      click_on 'Post your answer'
      
      expect(page).to have_content "Body can't be blank"
    end
    
    context 'create answer with' do
      scenario 'one or many files attached', js: true do
        fill_in 'Body', with: 'content answer'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Post your answer'

        within "[class^=row-answer]" do
          expect(page).to have_link 'rails_helper.rb'
          expect(page).to have_link 'spec_helper.rb'
        end
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'can\'t to post the answer' do
      visit question_path(question)

      expect(page).not_to have_button 'Post your answer'
    end
  end
end
