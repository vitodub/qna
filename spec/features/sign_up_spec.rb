require 'rails_helper'

feature 'User can sign up', %q{
  In order to ask questions
  As an unregistred user
  I'd like to be able to sign up
} do

  given(:user) { create(:user) }

  background { visit new_user_registration_path }

  scenario 'Unregistred user tries to sign up' do
    fill_in 'Email', with: 'test@test.com'
    fill_in 'Password', with: user.password
    fill_in 'Password confirmation', with: user.password_confirmation
    click_on 'Sign up'
 
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Unregistred user tries to sign up with errors' do
    fill_in 'Password', with: user.password
    click_on 'Sign up'

    expect(page).to have_content "Email can't be blank"
  end
end
