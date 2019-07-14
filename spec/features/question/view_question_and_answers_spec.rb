require 'rails_helper'

feature 'User can view a question and it\'s answers', %q{
  As an user
  I'd like to be able to view a question and it's answers on a question page
} do

  given(:question) do 
    create(:question) do |q|
      create_list(:answer, 2, question: q)
    end
  end

  scenario 'Authentication user can view a question and it\'s answers' do
    user = create(:user)
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
