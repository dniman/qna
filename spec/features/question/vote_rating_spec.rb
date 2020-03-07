require 'rails_helper'

feature 'User can view a vote rating of the question', %q{ 
  As an user
  I'd like to be able to see a vote rating of the question
} do

  given(:users) { create_list(:user, 2) }
  given(:questions) { create_list(:question, 2) }

  before(:each) do
    users.each do |user|
      user.votes.create(votable: questions.first, yes: 1)
      user.votes.create(votable: questions.last, yes: -1)
    end
  end

  describe 'Authenticated user' do    
    describe 'as an author' do
      before do
        sign_in(questions.first.user)
        visit questions_path
      end

      scenario 'can view the vote rating of the question to eq 2' do
        within ".questions" do
          within ".row-question-#{questions.first.id}" do
            within ".vote-rating" do
              expect(page).to have_content(2)
            end
          end 
        end
      end

      scenario 'can view the vote rating of the question to eq -2' do
        within ".questions" do
          within ".row-question-#{questions.last.id}" do
            within ".vote-rating" do
              expect(page).to have_content(-2)
            end
          end 
        end
      end
    end
   
    describe 'as not an author' do
      before do 
        sign_in(users.first)
        visit questions_path
      end

      scenario 'can view the vote rating of the question to eq 2' do
        within ".questions" do
          within ".row-question-#{questions.first.id}" do
            within ".vote-rating" do
              expect(page).to have_content(2)
            end
          end 
        end
      end
      
      scenario 'can view the vote rating of the question to eq -2' do
        within ".questions" do
          within ".row-question-#{questions.last.id}" do
            within ".vote-rating" do
              expect(page).to have_content(-2)
            end
          end 
        end
      end
    end
  end

  describe 'Unauthenticated user' do
    before { visit questions_path }
    
    scenario 'can view the vote rating of the question to eq 2' do
      within ".questions" do
        within ".row-question-#{questions.first.id}" do
          within ".vote-rating" do
            expect(page).to have_content(2)
          end
        end 
      end
    end

    scenario 'can view the vote rating of the question to eq -2' do
      within ".questions" do
        within ".row-question-#{questions.last.id}" do
          within ".vote-rating" do
            expect(page).to have_content(-2)
          end
        end 
      end
    end
  end
end
