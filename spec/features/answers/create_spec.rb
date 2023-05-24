require 'rails_helper'

feature 'User can give an answer', %q{
  In order to share my knowledge
  As an authenticated user
  I want to be able to create answers
} do

  given!(:question) { create(:question) }

  describe 'Authenticated user', js: true do
    given(:user) { create(:user) }

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to create an answer', js: true do

      fill_in 'Your answer', with: 'My answer'
      click_on 'Answer the question'

      within '.answers' do # чтобы убедиться, что ответ в списке, а не в форме
        expect(page).to have_content 'My answer'
      end
    end

    scenario 'tries to create answer with errors', js: true do

      click_on 'Answer the question'

      expect(page).to have_content "Body can't be blank"
    end

    scenario 'answers a question with attached files' do
      fill_in 'Your answer', with: 'My answer'
      attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]

      click_on 'Answer the question'

      expect(page).to have_link 'rails_helper.rb'
      expect(page).to have_link 'spec_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to write an answer' , js: true do
    visit question_path(question)
    click_on 'Answer the question'

    expect(page).to have_content 'You need to sign in or sign up before continuing.'
  end
end
