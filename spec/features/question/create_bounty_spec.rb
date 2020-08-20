require 'rails_helper'

feature 'User can create bounty to the question', %q{
  In order to stimulate user for the best answer to question
  As a question's author
  I'd like to be able to create bounty to the question 
} do
  
  given(:user) { create(:user) }

  before do
    sign_in(user)
    visit questions_path
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
  end

  context 'Authenticated user create bounty when asks question' do
    scenario 'with valid attributes', js: true do
      click_on 'create bounty'
      
      within '.bounty-fields' do
        fill_in 'Bounty name', with: 'bounty name'
        attach_file 'Image', "#{Rails.root}/spec/fixtures/sample_files/bounty.png"
      end
      
      click_on 'Save your question'

      within '.questions' do
        click_on 'Test question'
      end
      
      within '.bounty' do
        expect(page).to have_content 'bounty name'
      end
    end

    scenario 'with invalid attributes', js: true do
      click_on 'create bounty'

      within '.bounty-fields' do
        fill_in 'Bounty name', with: ''
        attach_file 'Image', "#{Rails.root}/spec/fixtures/sample_files/bounty.png"
      end

      click_on 'Save your question'
      
      within '.question-errors' do
        expect(page).to have_content 'Bounty name can\'t be blank'
      end
    end
  end
end
