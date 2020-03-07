require 'rails_helper'

feature 'User can view a vote rating of the answer', %q{ 
  As an user
  I'd like to be able to see a vote rating of the answer 
} do

  given(:users) { create_list(:user, 2) }
  given(:answers) { create_list(:answer, 2) }
  
  before(:each) do
    users.each do |user|
      user.votes.create(votable: answers.first, yes: 1)
      user.votes.create(votable: answers.last, yes: -1)
    end
  end

  describe 'Authenticated user' do
    describe 'as an author' do
      scenario 'can view the vote rating of the answer to eq 2' do
        sign_in(answers.first.user)
        visit question_path(answers.first.question)
        
        within ".answers" do
          within ".row-answer-#{answers.first.id}" do
            within ".vote-rating" do
              expect(page).to have_content(2)
            end
          end 
        end
      end
      
      scenario 'can view the vote rating of the answer to eq -2' do
        sign_in(answers.last.user)
        visit question_path(answers.last.question)
        
        within ".answers" do
          within ".row-answer-#{answers.last.id}" do
            within ".vote-rating" do
              expect(page).to have_content(-2)
            end
          end 
        end
      end
    end

    describe 'as not an author' do
      scenario 'can view the vote rating of the answer to eq 2' do
        sign_in(users.first)
        visit question_path(answers.first.question)
        
        within ".answers" do
          within ".row-answer-#{answers.first.id}" do
            within ".vote-rating" do
              expect(page).to have_content(2)
            end
          end 
        end
      end
      
      scenario 'can view the vote rating of the answer to eq -2' do
        sign_in(users.first)
        visit question_path(answers.last.question)
        
        within ".answers" do
          within ".row-answer-#{answers.last.id}" do
            within ".vote-rating" do
              expect(page).to have_content(-2)
            end
          end 
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    scenario 'can view the vote rating of the answer to eq 2' do
      visit question_path(answers.first.question)

      within ".answers" do
        within ".row-answer-#{answers.first.id}" do
          within ".vote-rating" do
            expect(page).to have_content(2)
          end
        end 
      end
    end
    
    scenario 'can view the vote rating of the answer to eq -2' do
      visit question_path(answers.last.question)

      within ".answers" do
        within ".row-answer-#{answers.last.id}" do
          within ".vote-rating" do
            expect(page).to have_content(-2)
          end
        end 
      end
    end
  end
end
