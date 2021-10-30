require 'sphinx_helper'

feature 'User can search for answer', %q{
  In order to find needed answer 
  As a User
  I'd like to be able to search for the answer
} do

  given!(:answers) { create_list(:answer, 2) }

  describe "User searches for the answer" do 
    context "with empty search" do
      scenario 'result 0', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: ''
            find("#resource option[value='Answers']").select_option

            click_button "Search"
          end

          expect(page).to have_content("Search result: 0")
        end
      end
    end
    
    context "with MyText search" do
      scenario 'result 2', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: 'MyText'
            find("#resource option[value='Answers']").select_option

            click_button "Search"
          end
          
          expect(page).to have_content("Search result: 2")
          expect(page).to have_content(/MyText/, count: 2)
        end
      end
    end
  end
end
