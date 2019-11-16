require 'rails_helper'

feature 'User can delete his question', %q{
  As an user
  I'd like to be able to delete my questions
} do
  
  describe 'Authenticated user' do
    given!(:users) { create_list(:user, 2) }
    given!(:question) { create(:question, user: users[0]) }

    scenario 'as an author can delete the question' do
      sign_in(users[0])
      
      visit questions_path
      click_on 'Delete'
      
      expect(page).to have_content 'Your question successfully deleted.'
    end

    scenario 'as not an author can\'t delete the question' do
      sign_in(users[1])
      
      visit questions_path
      
      expect(page).not_to have_link 'Delete'
    end
  end

  scenario 'Unauthenticated user try delete the question' do
    visit questions_path

    expect(page).not_to have_link 'Delete'
  end

end
