require 'rails_helper' 

feature 'User can unsubscribe to not receive an email', %q{
  In order to not know about new answers 
  As an authenticated user
  I'd like to be able to unsubscribe to not receive an email when a new question appears 
} do

  given!(:user) { create(:user) }
  given!(:questions) { [ create(:question), create(:question, user: user) ] }

  scenario 'Unauthenticated user can\'t unsubscribe for the question' do
    visit questions_path

    within ".question-row-#{ questions.first.id }" do
      within ".subscription-actions-#{ questions.first.id }", visible: false do
        expect(page).to have_no_css("form[action='/questions/#{questions.first.id}/unsubscribe']")
      end
    end
  end
  
  describe 'Authenticated user', js: true do
    context 'as an author of question' do
      before do 
        sign_in(questions.last.user) 
        questions.last.user.subscribe!(questions.last)
        visit questions_path
      end

      scenario 'can unsubscribe for the question' do
        within ".question-row-#{ questions.last.id }" do
          within "ul.subscription-actions-#{ questions.last.id }" do
            within "form[action='/questions/#{questions.last.id}/unsubscribe']" do
              find('.button.button-set').click
            end

            expect(page).to have_css("form[action='/questions/#{questions.last.id}/subscribe']")
          end
        end
      end
    end

    context 'as not an author of question' do
      before do 
        sign_in(user) 
        user.subscribe!(questions.first)
        visit questions_path
      end

      scenario 'can unsubscribe for the question' do
        within ".question-row-#{ questions.first.id }" do
          within "ul.subscription-actions-#{ questions.first.id }" do
            within "form[action='/questions/#{questions.first.id}/unsubscribe']" do
              find('.button.button-set').click
            end

            expect(page).to have_css("form[action='/questions/#{questions.first.id}/subscribe']")
          end
        end
      end
    end
  end
end

