require 'rails_helper'

include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector("div.alert.alert-error", text: "Invalid")
  end
end

def sign_in(user)
  visit signin_path
  fill_in "Email", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
  # Sign in when not using Capybara
  # Note: Not able to use a permanent cookie in an automated test
  cookies[:remember_token] = user.remember_token
end