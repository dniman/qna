require 'rails_helper'

feature 'User can view his bounties', %q{
  As a user
  I'd like to be able to view my bounties 
} do

  given!(:user) { create(:user) }
  given!(:questions) { create_list(:question, 2, user: user) } 
  given!(:bounties) { [ create(:bounty, :with_image, user: user, question: questions.first),
                       create(:bounty, :with_image, user: user, question: questions.last) ] }
  
  scenario 'Authenticated user can see his bounties', js: true do
    sign_in(user)

    visit questions_path

    expect(page).to have_content("My bounties") 

    click_on 'My bounties'

    expect(page).to have_content(/MyBounty/).twice 
    expect(page).to have_content(/MyString \d/).twice 
    expect(page).to have_css("img[src*='bounty.png']").twice
  end

end
