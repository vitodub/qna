require 'rails_helper'

feature 'User can edit his question' do
  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_2) { create(:question) }

  describe 'Authenticated user', js: true do
    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'tries to edit his question' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Edit question', with: 'edit body'
        click_on 'Save'

        expect(page).to_not have_content question.body
        expect(page).to have_content 'edit body'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'tries to edit his question with mistakes' do
      click_on 'Edit'

      within '.question' do
        fill_in 'Edit question', with: ''
        click_on 'Save'
      end

      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question" do
      visit question_path(question_2)

      expect(page).to have_no_link('Edit')
    end
  end

  scenario 'Unauthenticated user tries to edit question', js: true do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end
end
