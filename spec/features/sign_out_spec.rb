require 'rails_helper'

feature 'User can sign out', %q{
  In order to end session
  As an authenticated user
  I'd like to be able to sign out
} do

  given(:user) { create(:user) }

  scenario 'Registred user tries to sign out' do
    visit new_user_session_path
    sign_in(user)    
    click_on 'Sign out'

    expect(page).to have_content 'Signed out successfully.'
  end
end
