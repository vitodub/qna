require 'rails_helper'

feature 'User can edit his answer', %q{
  In order to correct mistakes
  As an author of answer
  I'd like ot be able to edit my answer
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_of_other_user) { create(:answer, question: question) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Edit'
  end

  describe 'Authenticated user' do

    background do
      sign_in(user)
      visit question_path(question)
    end

    scenario 'edits his answer', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Edit answer', with: 'edited answer'
        click_on 'Save'
            
        expect(page).to_not have_content answer.body
        expect(page).to have_content 'edited answer'
        expect(page).to_not have_selector 'textarea'
      end
    end

    scenario 'edits his answer with errors', js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Edit answer', with: ''
        click_on 'Save'
      end 
      expect(page).to have_content "Body can't be blank"
    end

    scenario "tries to edit other user's question", js: true do
      expect(page).to have_link('Edit', count: 1)      
    end

    scenario "adds files while editing", js: true do
      within '.answers' do
        click_on 'Edit'
        fill_in 'Edit answer', with: 'edited answer'

        attach_file 'File', ["#{Rails.root}/spec/rails_helper.rb", "#{Rails.root}/spec/spec_helper.rb"]
        click_on 'Save'
            
        expect(page).to have_link 'rails_helper.rb'
        expect(page).to have_link 'spec_helper.rb'
      end
    end
  end
end
