require 'sphinx_helper'

feature 'User can search for question', %q{
  In order to find needed question
  As a User
  I'd like to be able to search for the question
} do

  given!(:questions) { create_list(:question, 2) }

  describe "User searches for the question" do 
    context "with empty search" do
      scenario 'result 0', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: ''

            click_button "Search"
          end

          expect(page).to have_content("Search result: 0")
        end
      end
    end
    
    context "with MyString search" do
      scenario 'result 2', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: 'MyString'

            click_button "Search"
          end

          expect(page).to have_content("Search result: 2")
          expect(page).to have_content(/MyString \d/).twice
        end
      end
    end
  end
end
