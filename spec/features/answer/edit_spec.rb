require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like to be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }

  scenario 'Unauthenticated user can\'t edit an answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do
    scenario 'edits his answer', js: true do
      sign_in user
      visit question_path(question)

      
      within ".row-answer-#{answer.id}" do
        click_on 'Edit'
        expect(page).to have_selector('textarea', id: 'answer_body', exact_text: answer.body)

        fill_in 'Body', with: 'edited answer'
        click_on 'Save your answer'
        
        expect(page).to have_content 'edited answer'
        expect(page).not_to have_selector('textarea', id: 'answer_body', exact_text: answer.body)
      end
    end

    scenario 'edits his answer with errors', js: true do
      sign_in user
      visit question_path(question)
      
      within ".row-answer-#{answer.id}" do
        click_on 'Edit'
        
        fill_in 'Body', with: ''
        click_on 'Save your answer'
        
        expect(page).to have_content 'Body can\'t be blank'
      end
    end
    
    scenario 'tries to edit other user\'s answer' do
      other_user = create(:user)
      sign_in other_user
      visit question_path(question)

      within ".row-answer-#{answer.id}" do
        expect(page).not_to have_link 'Edit'
      end
    end
    
    context 'when edit his answer' do
      scenario 'can attach on file', js: true do
        sign_in(answer.user)
        visit question_path(question)
      
        within ".row-answer-#{answer.id}" do
          click_on 'Edit'
        
          attach_file 'File', "#{Rails.root}/spec/rails_helper.rb"        
          click_on 'Save your answer'

          click_on 'Show'
        end
        
        expect(page).to have_link 'rails_helper.rb'
      end
      
      scenario 'can attach many files', js: true do
        sign_in(answer.user)
        visit question_path(question)
      
        within ".row-answer-#{answer.id}" do
          click_on 'Edit'
          attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
          click_on 'Save your answer'

          click_on 'Show' 
        end
        
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
