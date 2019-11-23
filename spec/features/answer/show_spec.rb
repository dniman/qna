require 'rails_helper'

feature 'User can delete answer\'s files', %q{
  As an user
  I'd like to be able to delete answer's files
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer) }

  context 'Authenticated user' do
   
    scenario 'as an author can delete attached files', js: true do
      sign_in(answer.user)
      
      visit answer_path(answer)

      within ".row-file-#{answer.files.first.id}" do
        page.accept_confirm do
          click_link 'Delete'
        end
      end
      
      within ".row-file-#{answer.files.last.id}" do
        page.accept_confirm do
          click_link 'Delete'
        end
      end

      within ".files" do
        expect(page).not_to have_link('rails_helper.rb') 
        expect(page).not_to have_link('spec_helper.rb')
      end
    end

    scenario 'as not an author can\'t delete attached files' do
      visit answer_path(answer)
      
      within ".files" do
        expect(page).not_to have_link('Delete')
      end
    end
  end

  context 'Unauthenticated user' do
    scenario 'can\'t delete attached files' do
      visit answer_path(answer)

      within ".files" do
        expect(page).not_to have_link('Delete')
      end
    end
  end
end

