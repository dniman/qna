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

    click_on 'add link'
    click_on 'add link'
  end

  context 'Authenticated user adds links when asks question' do
    context 'with valid attibutes', js: true do
      scenario 'when links is gist' do
        gists = build_list(:link, 2, linkable: question, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(gists[index].name)
        end

        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(gists[index].url)
        end
        
        click_on 'Ask'

        click_on 'Test question'
        
        within '.question-links' do
          expect(page).to have_selector(:css, "script[src='#{gists.first.url}.js']", visible: false)
          expect(page).to have_selector(:css, "script[src='#{gists.last.url}.js']", visible: false)
        end
      end

      scenario 'when links is not gist' do
        links = build_list(:link, 2, linkable: question)

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end

        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(links[index].url)
        end
        
        click_on 'Ask'

        click_on 'Test question'

        within '.question-links' do
          expect(page).to have_link links.first.name, href: links.first.url
          expect(page).to have_link links.last.name, href: links.last.url
        end
      end
    end


    context 'with invalid attributes', js: true do
      scenario 'when url is empty' do
        links = build_list(:link, 2, linkable: question)

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end

        click_on 'Ask'

        expect(page).to have_content "Links url can't be blank"
      end
      
      scenario 'when url is invalid' do
        links = build_list(:link, 2, linkable: question)

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end

        click_on 'Ask'

        expect(page).to have_content "Links url is invalid"
      end
      
      scenario 'when link name is empty' do
        links = build_list(:link, 2, linkable: question, name: '')
        
        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(links[index].url)
        end

        click_on 'Ask'

        expect(page).to have_content "Links name can't be blank"
      end
    end
  end
end
