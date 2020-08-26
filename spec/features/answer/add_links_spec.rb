require 'rails_helper'
require 'securerandom'

feature 'User can add links to answer', %q{
  In order to provide additional info to my answer
  As an answer's author
  I'd like to be able to add links
} do

  given(:user) { create(:user) }
  given(:question) { create(:question) }
  given(:answer) { build(:answer, question: question) }

  context 'Authenticated user adds links when asks question' do
    before do
      sign_in(question.user)
      visit question_path(question)
      
      fill_in 'Body', with: 'content answer'

      click_on 'add link'
      click_on 'add link'
    end

    context 'with valid attibutes' do
      scenario 'when links is gist', js: true do
        gists = build_list(:link, 2, linkable: answer, url: "https://gist.github.com/#{SecureRandom.uuid.split('-').join('')}")

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(gists[index].name)
        end

        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(gists[index].url)
        end

        click_on 'Post your answer'
        
        within ".row-answer-#{ question.answers.last.id }" do
          expect(page).to have_selector(:css, "script[src='#{gists.first.url}.js']", visible: false)
          expect(page).to have_selector(:css, "script[src='#{gists.last.url}.js']", visible: false)
        end
      end
      
      scenario 'when links is not gist', js: true do
        links = build_list(:link, 2, linkable: answer)

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end

        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(links[index].url)
        end
        
        click_on 'Post your answer'

        within ".row-answer-#{ question.answers.last.id }" do
          expect(page).to have_link(links.first.name, href: links.first.url, visible: false)
          expect(page).to have_link(links.last.name, href: links.last.url, visible: false)
        end
      end
    end

    context 'with invalid attributes' do
      scenario 'when url is empty', js: true do
        links = build_list(:link, 2, linkable: answer)

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end

        click_on 'Post your answer'

        expect(page).to have_content "Links url can't be blank"
      end
      
      scenario 'when url is invalid', js: true do
        links = build_list(:link, 2, linkable: answer, url: 'google.com')

        all("input[name$='[name]']").each_with_index do |input, index|
          input.set(links[index].name)
        end
        
        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(links[index].url)
        end

        click_on 'Post your answer'
        
        expect(page).to have_content "Links url is invalid"
      end
      
      scenario 'when link name is empty', js: true do
        links = build_list(:link, 2, linkable: answer, name: '')
        
        all("input[name$='[url]']").each_with_index do |input, index|
          input.set(links[index].url)
        end

        click_on 'Post your answer'
        
        expect(page).to have_content "Links name can't be blank"
      end
    end
  end
end
