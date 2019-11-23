require 'rails_helper'

feature 'User can create question', %q{
  In order to get answer from a community
  As an authenticated user
  I'd like to be able to ask the question
} do

  given(:user) { create(:user) }

  describe 'Authenticated user' do
    background {
      sign_in(user)

      visit questions_path
    }

    scenario 'asks a question', js: true do
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'
      click_on 'Ask'

      within '.questions' do
        expect(page).to have_content 'Test question'
      end
    end

    scenario 'asks a question with errors', js: true do
      click_on 'Ask'
      expect(page).to have_content "Title can't be blank"
      expect(page).to have_content "Body can't be blank"
    end

    context 'asks a question with' do
      scenario 'one file attached', js: true do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"        
        click_on 'Ask'

        within '.questions' do
          click_on 'Test question'
        end
        
        expect(page).to have_link 'rails_helper.rb'
      end
      
      scenario 'many files attached', js: true do
        fill_in 'Title', with: 'Test question'
        fill_in 'Body', with: 'text text text'
        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Ask'

        within '.questions' do
          click_on 'Test question'
        end
        
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end 

  context 'Unauthenticated user' do
    scenario 'can\'t ask a question' do
      visit questions_path

      expect(page).not_to have_button 'Ask'
    end
  end
end

