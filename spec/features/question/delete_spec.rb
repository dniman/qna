require 'rails_helper'

feature 'User can delete his question', %q{
  As an user
  I'd like to be able to delete my questions
} do
  
  describe 'Authenticated user' do
    given(:author) do
      create(:user) do |u|
        create(:question, user: u)
      end
    end

    given(:user) { create(:user) }

    scenario 'as an author can delete the question' do
      sign_in(author)
      
      visit questions_path
      click_on 'Delete'
      
      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'as not an author can\'t delete the question' do
      sign_in(user)
      
      visit questions_path
      
      expect(page).not_to have_content 'Delete'
    end
  end

  scenario 'Unauthenticated user try delete the question' do
    visit questions_path

    expect(page).not_to have_content 'Delete'
  end

end
