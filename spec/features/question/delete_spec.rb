require 'rails_helper'

feature 'User can delete his question', %q{
  As an user
  I'd like to be able to delete my questions
} do
  
  describe 'Authenticated user' do
    given!(:user) { create(:user) }
    given!(:question) { create(:question) }

    scenario 'as an author can delete the question', js: true do
      sign_in(question.user)
      visit questions_path

      within ".question-row-#{question.id}" do
        expect(page).to have_content question.title
        
        page.accept_confirm do
          click_link 'Delete'
        end
      end
      
      within '.questions' do
        expect(page).not_to have_content question.title
      end
    end
      
    scenario 'as not an author can\'t delete the question', js: true do
      sign_in(user)
      
      visit questions_path
      
      within ".questions" do
        expect(page).not_to have_link 'Delete'
      end
    end
  end

  scenario 'Unauthenticated user try delete the question' do
    visit questions_path

    within ".questions" do
      expect(page).not_to have_link 'Delete'
    end
  end

end
