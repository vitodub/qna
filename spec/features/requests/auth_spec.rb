require 'rails_helper'

feature 'User can be authenticated from third party website', %q{
  In order to get fast access to questions and answers
  As an unauthenticated user
  I'd like to be able to authenticate from another website
}

describe "Unauthenticated user" do
  describe 'tries to sign in with GitHub' do
    scenario "with valid auth data" do
      mock_auth_github_valid_hash

      visit root_path
      click_on 'Sign in'
      click_on "Sign in with GitHub"

      expect(page).to have_content "Successfully authenticated from GitHub account."
      expect(page).to have_content "Sign out"
    end

    scenario "with invalid auth data" do
      mock_auth_github_invalid_hash

      visit root_path
      click_on 'Sign in'
      click_on "Sign in with GitHub"

      expect(page).to have_content 'Something went wrong'
    end
  end

  describe 'tries to sign in with Yandex' do
    scenario "with valid auth data" do
      mock_auth_yandex_valid_hash

      visit root_path
      click_on 'Sign in'
      click_on "Sign in with Yandex"

      expect(page).to have_content "Successfully authenticated from Yandex account."
      expect(page).to have_content "Sign out"
    end

    scenario "with invalid auth data" do
      mock_auth_yandex_invalid_hash

      visit root_path
      click_on 'Sign in'
      click_on "Sign in with Yandex"

      expect(page).to have_content 'Something went wrong'
    end
  end
end
