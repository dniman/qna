require 'rails_helper'

feature 'User can view a vote rating of the answer', %q{ 
  As an user
  I'd like to be able to see a vote rating of the answer 
} do

  given(:users) { create_list(:user, 2) }
  given(:answer) { create(:answer) }
  
  before(:each) do
    users.each do |user|
      user.votes.create(votable: answer)
    end
  end

  describe 'Authenticated user' do
    scenario 'as an author can view the vote rating of the answer' do
      sign_in(answer.user)
      visit question_path(answer.question)
      
      within ".answers" do
        within ".row-answer-#{answer.id}" do
          within ".vote-rating" do
            expect(page).to have_content(/(\d+)|(-\d+)/)
          end
        end 
      end
    end

    scenario 'as not an author can view the vote rating of the answer' do
      sign_in(users.first)
      visit question_path(answer.question)
      
      within ".answers" do
        within ".row-answer-#{answer.id}" do
          within ".vote-rating" do
            expect(page).to have_content(/(\d+)|(-\d+)/)
          end
        end 
      end
    end
  end

  scenario 'Unauthenticated user can view the vote rating of the answer' do
    visit question_path(answer.question)

    within ".answers" do
      within ".row-answer-#{answer.id}" do
        within ".vote-rating" do
          expect(page).to have_content(/(\d+)|(-\d+)/)
        end
      end 
    end
  end
end
