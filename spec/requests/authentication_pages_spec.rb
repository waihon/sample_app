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
      before { sign_in user }

      it { is_expected.to have_title(user.name) }
      it { is_expected.to have_link("Profile", href: user_path(user)) }
      it { is_expected.to have_link("Sign out", href: signout_path) }
      it { is_expected.not_to have_link("Sign in", href: signin_path) }
      it { is_expected.to have_link("Settings", href: edit_user_path(user)) }
      it { is_expected.not_to have_link("Sign in", href: signin_path) }

      describe "followed by signout" do
        before { click_link "Sign out" }
        it { is_expected.to have_link("Sign in") }
      end
    end
  end

  describe "authorization" do

    describe "for non-signed-in user" do
      let(:user) { FactoryGirl.create(:user) }

      describe "when attempting to visit a protected page" do
        before do
          visit edit_user_path(user)
          fill_in "Email", with: user.email
          fill_in "Password", with: user.password
          click_button "Sign in"
        end

        describe "after signing in" do
          it "should render the desired protected page" do
            expect(page).to have_title("Edit user")
          end

          describe "when signing in again" do
            before do
              click_link "Sign out"
              click_link "Sign in"
              fill_in "Email", with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            it "should render the default (profile) page" do
              expect(page).to have_title(user.name)
            end
          end
        end
      end

      describe "in the Users controller" do
        describe "visiting the edit page" do
          before { visit edit_user_path(user) }

          it { is_expected.to have_title("Sign in") }
          it { is_expected.to have_selector("div.alert.alert-notice") }
        end

        describe "submitting to the update action" do
          # HTTP: get post put delete
          before { put user_path(user) }
          specify { expect(response).to redirect_to(signin_path) }
        end
      end
    end

    describe "as wrong user" do
      let(:user) { FactoryGirl.create(:user) }
      let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
      before { sign_in user} 

      describe "visiting Users#edit page" do
        before { visit edit_user_path(wrong_user) }
        it { is_expected.not_to have_title("Edit user") }
      end

      describe "submitting a PUT request to the User#update action" do
        before { put user_path(wrong_user) }
        specify { expect(response).to redirect_to(root_path) }
      end
    end
  end

end
