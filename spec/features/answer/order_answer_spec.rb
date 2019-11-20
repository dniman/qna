require 'rails_helper'

feature 'Display the best answer first in the list of answers', %q{
  As a user of system
  I'd like to be able to see the best answer first
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create_list(:answer, 2, question: question, user: user) }

  before { answer[1].update(best_answer: true) }

  scenario 'Unauthenticated user can see the best answer first' do
    visit question_path(question)
    item = find('.answers tr:nth-of-type(2) td:nth-of-type(5)').text
      
    expect(item).to eq('Best answer')
  end

  scenario 'Authenticated user can see the best answer first' do
    sign_in(user)
    visit question_path(question)
    item = find('.answers tr:nth-of-type(2) td:nth-of-type(5)').text
      
    expect(item).to eq('Best answer')
  end
end

