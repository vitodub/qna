require 'rails_helper'

feature 'User can view all his received rewards', %q{
  In order to see my rewards
  As an authenticated user
  I'd like to be able to see all my rewards
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given(:reward_achievement) { create(:reward_achievement, user: user) }

  scenario 'Authenticated user tries to view his rewards' do
    reward_achievement

    sign_in(user)

    click_on 'My Rewards'

    expect(page).to have_content 'Question №1'
    expect(page).to have_content 'BasicRewardNameString'
    expect(find('.reward-image')['src']).to have_content 'best_answer_reward.png'
  end

  scenario 'Unauthenticated user tries to view rewards' do
    visit(questions_path)

    expect(page).not_to have_content 'My Rewards'
  end
end
