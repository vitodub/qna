require 'rails_helper'

feature "User can see gist content of question's links", %q{
  In order to see gist content
  As an user
  I'd like to be able to see gist content
} do

  given(:question_with_gist_link) { create(:question, :with_gist_link }
  
  scenario "User tries to see gist content on question's page", js: true do
    visit question_path(question_with_gist_link)

    expect(page).to have_content 'GET /anything HTTP/1.1'
    expect(page).to have_content 'url": "http://httpbin.com/anything'
  end
end
