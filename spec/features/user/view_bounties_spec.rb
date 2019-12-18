require 'rails_helper'

feature 'User can view his bounties', %q{
  As a user
  I'd like to be able to view my bounties 
} do

  given!(:user) { create(:user) }

  context 'Authenticated user' do
    scenario 'see his bounties', js: true do
      questions = create_list(:question, 2, user: user)
      bounties = [ create(:bounty, :with_image, user: questions.first.user, question: questions.first),
                   create(:bounty, :with_image, user: questions.last.user, question: questions.last)
      ]

      sign_in(user)

      visit questions_path

      expect(page).to have_content("My bounties") 

      click_on 'My bounties'

      expect(page).to have_content(/MyBounty/).twice 
      expect(page).to have_content(/MyString \d/).twice 
      expect(page).to have_css("img[src*='bounty.png']").twice
    end

    scenario 'do not see other\'s bounties', js: true do
      questions = [ create(:question, user: user),
                    create(:question) 
      ]
      
      bounties = [ create(:bounty, :with_image, user: questions.first.user, question: questions.first),
                   create(:bounty, :with_image, user: questions.last.user, question: questions.last)
      ]
      
      sign_in(user)

      visit questions_path

      expect(page).to have_content("My bounties") 

      click_on 'My bounties'

      expect(page).to have_content(/MyBounty/).once 
      expect(page).to have_content(/MyString \d/).once 
      expect(page).to have_css("img[src*='bounty.png']").once
    end
  end
end
