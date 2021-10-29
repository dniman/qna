require 'sphinx_helper'

feature 'User can search for user', %q{
  In order to find needed user 
  As a User
  I'd like to be able to search for the user
} do

  given!(:user) { create_list(:user, 2) }

  describe "User searches for the user" do 
    context "with empty search" do
      scenario 'result 0', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: ''
            find("#resource option[value='Users']").select_option

            click_button "Search"
          end

          expect(page).to have_content("Search result: 0")
        end
      end
    end
    
    context "with com search" do
      scenario 'result 2', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: 'com'
            find("#resource option[value='Users']").select_option
            
            click_button "Search"
          end
          
          expect(page).to have_content("Search result: 2")
          expect(page).to have_content(/com/, count: 2)
        end
      end
    end
  end
end
