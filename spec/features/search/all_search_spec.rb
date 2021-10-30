require 'sphinx_helper'

feature 'User can search for all resources', %q{
  In order to find needed question,answer,user,comment 
  As a User
  I'd like to be able to search for the question,answer,user,comment
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, title: "com", user: user) }
  given!(:answer) { create(:answer, body: "com", user: user, question: question) }
  given!(:comment) { create(:comment, body: "com", commentable: question, user: user) }

  describe "User searches for the all resources" do 
    context "with empty search" do
      scenario 'result 0', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: ''
            find("#resource option[value='All']").select_option

            click_button "Search"
          end

          expect(page).to have_content("Search result: 0")
        end
      end
    end
    
    context "with com search" do
      scenario 'result 4', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: 'com'
            find("#resource option[value='All']").select_option
            
            click_button "Search"
          end
          
          expect(page).to have_content("Search result: 4")
          expect(page).to have_content(/com/, count: 4)
        end
      end
    end
  end
end
