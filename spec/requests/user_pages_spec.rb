require 'rails_helper'

RSpec.describe "UserPages", type: :request do

  subject { page }

  describe "GET /user_pages" do
    it "works! (now write some real specs)" do
      # get user_pages_index_path
      # expect(response).to have_http_status(200)
    end
  end

  describe "signup page" do
    before { visit signup_path }

    it { is_expected.to have_selector("h1", text: "Sign up") }
    it { is_expected.to have_title(full_title("Sign up")) }
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { is_expected.to have_selector("h1", text: user.name) }
    it { is_expected.to have_title(user.name) }
  end

  describe "signup" do
    before { visit signup_path }

    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end

      describe "after submission" do
        before { click_button submit }

        it { is_expected.to have_title("Sign up") }
        it { is_expected.to have_content("error") }
        it { is_expected.not_to have_content("Password digest") }
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

      describe "after saving a user" do
        before { click_button submit }

        let(:user) { User.find_by_email("user@example.com") }

        it { should have_title(user.name) }
        it { is_expected.to have_selector("div.alert.alert-success", text: "Welcome") }
      end
    end
  end
end
