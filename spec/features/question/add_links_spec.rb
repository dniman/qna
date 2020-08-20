require 'rails_helper'

feature 'User can add links to question', %q{
  In order to provide additional info to my question
  As an question's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { build(:question) }

  before do
    sign_in(user)
    visit questions_path
    
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text text'
    
    within '.question-links' do
      click_on 'add link'
      click_on 'add link'
    end
  end

  context 'Authenticated user adds links when asks question', js: true do
    context 'with valid attibutes' do
      scenario 'when links is gist' do
        gists = build_list(:link, 2, linkable: question, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")

        within '.question-links' do
          all("input[name$='[name]']").each_with_index do |input, index|
            input.set(gists[index].name)
          end

          all("input[name$='[url]']").each_with_index do |input, index|
            input.set(gists[index].url)
          end
        end
       
        within '.new_question' do
          click_button 'Save your question'
        end

        within '.questions' do
          click_link "Test question"
        end
        
        within '.question-links', visible: false do
          expect(page).to have_selector(:css, "script[src='#{gists.first.url}.js']", visible: false)
          expect(page).to have_selector(:css, "script[src='#{gists.last.url}.js']", visible: false)
        end
      end

      scenario 'when links is not gist' do
        links = build_list(:link, 2, linkable: question)

        within '.question-links' do
          all("input[name$='[name]']").each_with_index do |input, index|
            input.set(links[index].name)
          end

          all("input[name$='[url]']").each_with_index do |input, index|
            input.set(links[index].url)
          end
        end
        
        within '.new_question' do
          click_button 'Save your question'
        end

        within '.questions' do
          click_link "Test question"
        end

        within '.question-links', visible: false do
          expect(page).to have_link(links.first.name, href: links.first.url, visible: false)
          expect(page).to have_link(links.last.name, href: links.last.url, visible: false)
        end
      end
    end

    context 'with invalid attributes' do
      scenario 'when url is empty' do
        links = build_list(:link, 2, linkable: question)

        within '.question-links' do
          all("input[name$='[name]']").each_with_index do |input, index|
            input.set(links[index].name)
          end
        end

        click_button 'Save your question'

        expect(page).to have_content "Links url can't be blank"
      end
      
      scenario 'when url is invalid' do
        links = build_list(:link, 2, linkable: question)

        within '.question-links' do
          all("input[name$='[name]']").each_with_index do |input, index|
            input.set(links[index].name)
          end
        end

        click_button 'Save your question'

        expect(page).to have_content "Links url is invalid"
      end
      
      scenario 'when link name is empty' do
        links = build_list(:link, 2, linkable: question, name: '')
        
        within '.question-links' do
          all("input[name$='[url]']").each_with_index do |input, index|
            input.set(links[index].url)
          end
        end

        click_button 'Save your question'

        expect(page).to have_content "Links name can't be blank"
      end
    end
  end
end
