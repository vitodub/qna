require 'rails_helper'

feature 'User can destroy the answer', %q{
  In order to destroy the user's answer
  As an user
  I'd like to be able to destroy my answer
} do

  given(:user) { create(:user) }
  given(:other_user) { create(:user) }
  given(:question) { create(:question, user: user) }

  #Опять почему-то работает только given!, а не given
  given!(:answer) { create(:answer, question: question, user: user) }

  describe 'Authenticated user' do

    scenario 'tries to destroy his answer' do
      sign_in(user)
      visit question_path(question)
      click_on 'Delete answer'

      expect(page).to have_content 'Your answer successfully deleted.'
    end

    scenario 'tries to destroy answer of another user' do
      sign_in(other_user)
      visit question_path(question)

      expect(page).to have_no_content 'Delete answer'
    end
  end

  scenario 'Unauthenticated user tries to destroy an answer' do
    visit question_path(question)

    expect(page).to have_no_content 'Delete answer'
  end
end
