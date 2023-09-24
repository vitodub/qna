require 'rails_helper'

feature "User can mark one of his question's answer as best", %q{
  In order to mark best answer
  As an author of question
  I'd like ot be able to mark it as best
} do

  given!(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:question_with_reward) { create(:question, user: user) }
  given!(:reward) { create(:reward, rewardable: question_with_reward) }
  given!(:answer) { create(:answer, question: question, user: user) }
  given!(:answer_2) { create(:answer, question: question) }
  given!(:rewarded_answer) { create(:answer, question: question_with_reward, user: user) }

  scenario 'Unauthenticated can not edit answer' do
    visit question_path(question)

    expect(page).to_not have_link 'Mark as best'
  end

  describe 'Authenticated user' do

    describe 'marks best answer', js: true do
      scenario "question doesn't have a reward", js: true do
        answer
        sign_in(user)
        visit question_path(question)

        within '.answers' do
          find("#answer-#{answer.id} .best_answer_link").click
      
          expect(page).to have_content 'Best answer'
        end
      end

      scenario "question has a reward", js: true do
        rewarded_answer
        reward
        sign_in(user)
        visit question_path(question_with_reward)

        within '.answers' do
          find("#answer-#{rewarded_answer.id} .best_answer_link").click
      
          expect(page).to have_content 'BasicRewardNameString'
        end
      end
    end

    scenario 'marks another best answer', js: true do
      sign_in(user)
      visit question_path(question)
      
      within '.answers' do
        find("#answer-#{answer.id} .best_answer_link").click
        find("#answer-#{answer_2.id} .best_answer_link").click

        within '.best_answer' do
          expect(page).to have_content answer_2.body
        end
      end
    end

  end
end
