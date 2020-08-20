require 'rails_helper'

feature 'User can delete links added to question', %q{
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  
  context 'Authenticated user', js: true do
    scenario 'can delete links when add new question' do
      sign_in(user)
      visit questions_path
      
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text text'

      click_on 'add link'
    
      within '.question-links' do
        within '.nested-fields' do
          expect(page).to have_selector(:css, "input[name$='[name]']", visible: true, count: 1)
          expect(page).to have_selector(:css, "input[name$='[url]']", visible: true, count: 1)
          expect(page).to have_link('delete link')

          click_on 'delete link'
        end
      
        expect(page).not_to have_selector(:css, "input[name$='[name]']")
        expect(page).not_to have_selector(:css, "input[name$='[url]']")
      end
      
      expect(page).not_to have_link('delete link')
    end
    
    context 'as an author', js: true do
      scenario 'deletes links added to question' do
        question = create(:question, :with_links) 

        sign_in(question.user)
        visit question_path(question)

        click_on 'Links'
      
        within '.question-links' do
          link = question.links.first
          
          expect(page).to have_link link.name, href: "#{link.url}"

          within ".link-#{link.id}" do
            page.accept_confirm do
              click_link 'Delete'
            end
          end
          
          expect(page).not_to have_link link.name
        end
      end

      scenario 'delete gists added to question' do
        question = create(:question, :with_gists)

        sign_in(question.user)
        visit question_path(question)

        click_on 'Links'
        
        within '.question-links' do
          gist = question.links.first
          
          expect(page).to have_selector(:css, "script[src='#{gist.url}.js']", visible: false)

          within ".link-#{gist.id}" do
            page.accept_confirm do
              click_link 'Delete'
            end
          end

          expect(page).not_to have_selector(:css, "script[src='#{gist.url}.js']")
        end
      end
    end

    context 'as not an author', js: true do
      scenario 'can\'t delete links added to question' do
        question = create(:question, :with_links) 

        sign_in(user)
        visit question_path(question)

        click_on 'Links'
        
        within '.question-links' do
          link = question.links.first
          
          expect(page).to have_link link.name, href: "#{link.url}"

          within ".link-#{link.id}" do
            expect(page).not_to have_link 'Delete' 
          end
        end
      end
    end
  end

end
