require 'rails_helper'

feature 'User can delete links added to question', %q{
  As an question's author
  I'd like to be able to delete links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  
  context 'Authenticated user' do
    scenario 'can delete links when add new answer', js: true do
      sign_in(user)
      visit question_path(question)
      
      fill_in 'Body', with: 'content answer'

      click_on 'add link'

      within '.nested-fields' do
        expect(page).to have_selector(:css, "input[name$='[name]']", visible: true, count: 1)
        expect(page).to have_selector(:css, "input[name$='[url]']", visible: true, count: 1)
        expect(page).to have_link('delete link')

        click_on 'delete link'
      end
      
      expect(page).not_to have_selector(:css, "input[name$='[name]']")
      expect(page).not_to have_selector(:css, "input[name$='[url]']")
      expect(page).not_to have_link('delete link')
    end
    
    context 'as an author' do
      scenario 'deletes links added to answer', js: true do
        answer = create(:answer, :with_links, question: question) 

        sign_in(answer.user)
        visit question_path(question)
        
        within ".row-answer-#{answer.id}" do
          click_link 'Links'
      
          within '.answer-links' do
            link = answer.links.first
            
            expect(page).to have_link link.name, href: "#{link.url}"

            within ".link-#{link.id}" do
              page.accept_confirm do
                click_link 'Delete'
              end
            end
            
            expect(page).not_to have_link link.name
          end
        end
      end

      scenario 'delete gists added to answer', js: true do
        answer = create(:answer, :with_gists, question: question)

        sign_in(answer.user)
        visit question_path(question)
        
        within ".row-answer-#{answer.id}" do
          click_link 'Links'
        
          within '.answer-links' do
            gist = answer.links.first
            
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
    end

    context 'as not an author' do
      scenario 'can\'t delete links added to answer', js: true do
        answer = create(:answer, :with_links, question: question)

        sign_in(user)
        visit question_path(question)

        within ".row-answer-#{answer.id}" do
          click_link 'Links'
        
          within '.answer-links' do
            link = answer.links.first
            
            expect(page).to have_link link.name, href: "#{link.url}"

            within ".link-#{link.id}" do
              expect(page).not_to have_link 'Delete' 
            end
          end
        end
      end
    end
  end

end
