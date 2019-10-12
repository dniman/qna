require 'rails_helper'

feature 'User can delete his answer', %q{
  As a user
  I'd like to be able to delete my answers
} do
  
  given(:author) do
    create(:user) do |u|
      create(:question, user: u) do |q|
        create(:answer, question: q, user: u)
      end
    end
  end

  given(:question) { author.questions.first }

  describe 'Authenticated user' do
    given(:user) { create(:user) }

    scenario 'as an author can delete the answer' do
      sign_in(author)
      
      visit question_path(question)
      click_on 'Delete'
      
      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'as not an author can\'t delete the answer' do
      sign_in(user)
      
      visit question_path(question)
      
      expect(page).not_to have_content 'Delete'
    end
  end

  scenario 'Unathenticated user try delete the answer' do
    visit question_path(question)

    expect(page).not_to have_content 'Delete'
  end
end
