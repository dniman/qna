require 'rails_helper'

feature 'User can view a vote rating of the question', %q{ 
  As an user
  I'd like to be able to see a vote rating of the question
} do

  given(:users) { create_list(:user, 2) }
  given(:question) { create(:question) }

  before(:each) do
    users.each do |user|
      user.votes.create(votable: question)
    end
  end

  describe 'Authenticated user' do    
    scenario 'as an author can view the vote rating of the question' do
      sign_in(question.user)
      visit questions_path
      
      within ".questions" do
        within ".row-question-#{question.id}" do
          within ".vote-rating" do
            expect(page).to have_content(/(\d+)|(-\d+)/)
          end
        end 
      end
    end
    
    scenario 'as not author can view the vote rating of the question' do
      sign_in(users.first)
      visit questions_path
      
      within ".questions" do
        within ".row-question-#{question.id}" do
          within ".vote-rating" do
            expect(page).to have_content(/(\d+)|(-\d+)/)
          end
        end 
      end
    end
  end

  scenario 'Unauthenticated user can view the vote rating of the question' do
    visit questions_path
    
    within ".questions" do
      within ".row-question-#{question.id}" do
        within ".vote-rating" do
          expect(page).to have_content(/(\d+)|(-\d+)/)
        end
      end 
    end
  end
end
