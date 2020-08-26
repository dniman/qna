require 'rails_helper'

feature 'User can delete question files', %q{
  As an user
  I'd like to be able to delete question's files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, :with_files) }

  context 'Authenticated user' do
   
    scenario 'as an author can delete attached files', js: true do
      sign_in(question.user)
      
      visit question_path(question)
      click_on 'Files'
      
      within ".question-files" do
        expect(page).to have_link('rails_helper.rb') 
        expect(page).to have_link('spec_helper.rb')
      end

      within ".row-file-#{question.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete'
        end
      end
      
      within ".row-file-#{question.files.last.id}" do
        page.accept_confirm do
          click_link 'Delete'
        end
      end

      within ".question-files" do
        expect(page).not_to have_link('rails_helper.rb') 
        expect(page).not_to have_link('spec_helper.rb')
      end
    end

    scenario 'as not an author can\'t delete attached files' do
      visit question_path(question)
      
      within ".question-files" do
        expect(page).not_to have_link('Delete').twice
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'can\'t delete attached files' do
      visit question_path(question)

      within ".question-files" do
        expect(page).not_to have_link('Delete').twice
      end
    end
  end
end

