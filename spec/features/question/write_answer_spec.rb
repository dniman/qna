require 'rails_helper'

feature 'User can write an answer on a question page', %q{
  In order to answer a question
  As an user
  I'd like to be able to write an answer on a question page
} do

  given(:question) { create(:question) }

  scenario 'Authenticated user can write the answer' do
    user = create(:user)
    sign_in(user)

    visit question_path(question)
    
    fill_in 'Body', with: 'content answer'
    click_on 'Post your answer'

    expect(page).to have_content 'Your answer was successfully created.'
  end

  scenario 'Unathenticated user can\'t write the answer' do
    visit question_path(question)

    expect(page).not_to have_button 'Post your answer'
  end

end
