require 'rails_helper'

feature 'User can view question with all answers', %q{
  In order to view all question's answers
  As a user
  I'd like to be able to view all answers
} do
    given(:question) { create(:question) }

    given!(:answers) { create_list(:answer, 3, question: question) }

    scenario 'User can view all answers' do
      visit question_path(question)
      answers.each { |answer| expect(page).to have_content answer.body }
    end
end
