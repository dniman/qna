require 'sphinx_helper'

feature 'User can search for comment', %q{
  In order to find needed comment
  As a User
  I'd like to be able to search for the comment
} do

  given!(:question) { create(:question) }
  given!(:comments) { create_list(:comment, 2, commentable: question) }

  describe "User searches for the comment" do 
    context "with empty search" do
      scenario 'result 0', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: ''
            find("#resource option[value='Comments']").select_option

            click_button "Search"
          end

          expect(page).to have_content("Search result: 0")
        end
      end
    end
    
    context "with MyComment search" do
      scenario 'result 2', sphinx: true, js: true do
        visit questions_path

        ThinkingSphinx::Test.run do
          within ".search-bar" do
            fill_in 'search', with: 'MyComment'
            find("#resource option[value='Comments']").select_option

            click_button "Search"
          end
          
          expect(page).to have_content("Search result: 2")
          expect(page).to have_content(/MyComment/, count: 2)
        end
      end
    end
  end
end
