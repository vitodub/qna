require 'rails_helper'

feature 'User can view questions list', %q{
  In order to view all questions
  As a user
  I'd like to be able to view questions list
} do

  # Подскажи, пожалуйста, почему given не создает вопросы, а создает только given!
  given!(:questions) { create_list(:question, 5) }

  scenario 'User can view all questions' do
    visit questions_path
    questions.each { |question| expect(page).to have_content question.title }
  end
end
