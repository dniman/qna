require 'rails_helper'

feature 'User can view a question and it\'s answers', %q{
  As an user
  I'd like to be able to view a question and it's answers on a question page
} do

  given!(:users) { create_list(:user, 2) }
  given!(:question) { create(:question, user: users[0]) }
  given!(:answers) { create_list(:answer, 2, question: question, user: users[0]) }

  describe 'Authenticated user' do
    scenario 'as author can view a question and it\'s answers' do
      sign_in(users[0])

      visit question_path(question)

      expect(page).to have_content('MyString')
      expect(page).to have_content('MyText').at_least(2)
    end

    scenario 'as user can view a question and it\'s answers' do
      sign_in(users[1])

      visit question_path(question)

      expect(page).to have_content('MyString')
      expect(page).to have_content('MyText').at_least(2)
    end
  end

  scenario 'Unathenticated user can view a question and it\'s answers' do
    visit question_path(question)
    
    expect(page).to have_content('MyString')
    expect(page).to have_content('MyText').at_least(2)
  end
end
