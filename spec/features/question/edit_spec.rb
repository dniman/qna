require 'rails_helper'

feature 'User can edit his question', %q{
  In order to correct mistakes
  As an author of question 
  I'd like to be able to edit my question
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }

  scenario 'Unauthenticated user can\'t edit a question' do
    visit questions_path

    expect(page).not_to have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his question', js: true do
      sign_in(question.user)
      visit questions_path
      
      click_on 'Edit'

      within ".row-question-#{question.id}" do
        expect(page).to have_selector("input[value='#{question.title}']")
        expect(page).to have_selector('textarea', id: 'question_body', exact_text: question.body)

        fill_in 'Title', with: 'edited title'
        fill_in 'Body', with: 'edited answer'
        click_on 'Save your question'
        
        expect(page).to have_content 'edited title'
        expect(page).not_to have_selector("input[value='#{question.title}']")
        expect(page).not_to have_selector('textarea', id: 'question_body', exact_text: question.body)
      end   
    end

    scenario 'tries to edit other user\'s question' do
      sign_in(user)
      visit questions_path

      within ".row-question-#{question.id}" do
        expect(page).not_to have_link 'Edit'
      end
    end
    
    context 'when edit his question' do
      scenario 'can attach one or many files', js: true do
        sign_in(question.user)
        visit questions_path
      
        within ".row-question-#{question.id}" do
          click_on 'Edit'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save your question'

          click_on question.title 
        end

        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
