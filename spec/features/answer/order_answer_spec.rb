require 'rails_helper'

feature 'Display the best answer first in the list of answers', %q{
  As a user of system
  I'd like to be able to see the best answer first
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answers) { create_list(:answer, 2, question: question, user: user) }

  before { answers.last.update(best_answer: true) }

  scenario 'Unauthenticated user can see the best answer first' do
    visit question_path(question)
          
    item = find('.question-answers > div:nth-of-type(2)')
      
    expect(item[:class]).to include('best-answer')
    expect(item[:class]).to include("row-answer-#{ answers.last.id }")
  end

  scenario 'Authenticated user can see the best answer first' do
    sign_in(user)
    visit question_path(question)

    item = find('.question-answers > div:nth-of-type(2)')
      
    expect(item[:class]).to include('best-answer')
    expect(item[:class]).to include("row-answer-#{ answers.last.id }")
  end
end

