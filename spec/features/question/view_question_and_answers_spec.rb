require 'rails_helper'

feature 'User can view a question and it\'s answers', %q{
  As an user
  I'd like to be able to view a question and it's answers on a question page
} do

  given(:user) do 
    create(:user) do |u|
      create(:question, user: u) do |q|
        create_list(:answer, 2, question: q, user: u)
      end
    end
  end
  given(:question) { user.questions.first }

  scenario 'Authentication user can view a question and it\'s answers' do
    sign_in(user)

    visit question_path(question)

    expect(page).to have_content('MyString')
    expect(page).to have_content('MyText').at_least(2)
  end

  scenario 'Unathenticated user can view a question and it\'s answers' do
    visit question_path(question)

    expect(page).to have_content('MyString')
    expect(page).to have_content('MyText').at_least(2)
  end
end
