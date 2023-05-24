require 'rails_helper'

feature 'User can destroy the question', %q{
  In order to destroy the user's question
  As an user
  I'd like to be able to destroy my question
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }


  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    scenario 'tries to destroy his question', js: true do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete question'

      expect(page).not_to have_content question.body
    end

    scenario 'tries to destroy question of another user' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_no_content 'Delete question'
    end

    scenario 'destroys file of question', js: true do
      sign_in(user)
      question.files.attach(io: File.open("#{Rails.root}/spec/rails_helper.rb"), filename: "rails_helper.rb")
      visit question_path(question)

      click_on 'Delete file'
      expect(page).to have_no_link 'rails_helper.rb'
    end
  end

  scenario 'Unauthenticated user tries to destroy an question' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete question'
  end
end
