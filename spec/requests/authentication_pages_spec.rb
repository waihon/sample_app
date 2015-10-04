require 'rails_helper'

RSpec.describe "AuthenticationPages", type: :request do
  # describe "GET /authentication_pages" do
  #   it "works! (now write some real specs)" do
  #     get authentication_pages_index_path
  #     expect(response).to have_http_status(200)
  #   end
  # end

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { is_expected.to have_selector("h1", text: "Sign in") }
    it { is_expected.to have_title("Sign in") }

    describe "signin" do
      before { click_button "Sign in" }

      describe "with invalid information" do
        it { is_expected.to have_title("Sign in") }
        it { is_expected.to have_error_message }

        describe "after visiting another page" do
          before { click_link "Home" }
          it { is_expected.not_to have_error_message }
        end
      end
    end

    describe "with valid information" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        fill_in "Email", with: user.email
        fill_in "Password", with: user.password
        click_button "Sign in"
      end

      it { is_expected.to have_title(user.name) }
      it { is_expected.to have_link("Profile", href: user_path(user)) }
      it { is_expected.to have_link("Sign out", href: signout_path) }
      it { is_expected.not_to have_link("Sign in", href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { is_expected.to have_link("Sign in") }
      end
    end
  end
end
