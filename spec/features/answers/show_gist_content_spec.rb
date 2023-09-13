require 'rails_helper'

feature "User can see gist content of answer's links", %q{
  In order to see gist content
  As an user
  I'd like to be able to see gist content
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:answer_with_gist_link) { create(:answer, :with_gist_link, user: user, question: question) }
  
  scenario "User tries to see gist content on question's page", js: true do
    answer_with_gist_link
    visit question_path(question)

    expect(page).to have_content 'GET /anything HTTP/1.1'
    expect(page).to have_content 'url": "http://httpbin.com/anything'
  end

  scenario 'Authenticated user tries to create an answer and see gist content of this answer', js: true do
    sign_in(user)
    visit question_path(question)

    fill_in 'Your answer', with: 'My answer'
    fill_in 'Link name', with: 'My gist'
    fill_in 'Url', with: 'https://gist.github.com/vitodub/5f67fadb25120be0220378d5e5dbfbeb'

    click_on 'Answer the question'

    within '.answers' do
      expect(page).to have_content 'GET /anything HTTP/1.1'
      expect(page).to have_content 'url": "http://httpbin.com/anything'
    end
  end
end
