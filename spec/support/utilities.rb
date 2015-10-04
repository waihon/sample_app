require 'rails_helper'

include ApplicationHelper

RSpec::Matchers.define :have_error_message do |message|
  match do |page|
    expect(page).to have_selector("div.alert.alert-error", text: "Invalid")
  end
end