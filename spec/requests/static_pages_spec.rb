require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /static_pages/home" do
    it "works! (now write some real specs)" do
      get root_path
      expect(response).to have_http_status(200)
    end    
  end

  describe "Static pages" do

    subject { page } 

    describe "Home page" do

      before { visit root_path }

      # it "should have the h1 'Sample App'" do
      #   expect(page).to have_selector("h1", text: "Sample App")
      # end
      it { should have_selector("h1", text: "Sample App")   }

      it { should have_title(full_title("")) }

      it { should_not have_title(" | Home") }
    end  

    describe "Help page" do

      before { visit help_path }

      it { should have_selector("h1", "Help") }

      it { should have_title(full_title("Help")) }
    end

    describe "About page" do

      before { visit about_path }

      it { should have_selector("h1", "About Us") }

      it { should have_title(full_title("About Us")) }
    end

    describe "Content page" do

      before { visit contact_path }

      it { should have_selector("h1", text: "Contact") }

      it { should have_title(full_title("Contact")) }
    end
  end

  it "should have the right links on the layout" do
    visit root_path
    click_link "About"
    expect(page).to have_title full_title("About Us")
    click_link "Help"
    expect(page).to have_title full_title("Help")
    click_link "Contact"
    expect(page).to have_title full_title("Contact")
    click_link "Home"
    click_link "Sign up now!"
    expect(page).to have_title full_title("Sign up")
  end  
end