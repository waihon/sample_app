require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /static_pages/home" do
    it "works! (now write some real specs)" do
      get static_pages_home_path
      expect(response).to have_http_status(200)
    end    
  end

  describe "Static pages" do
    describe "Home page" do
      it "should have the h1 'Sample App'" do
        visit static_pages_home_path
        #expect(page).to have_content("Sample App")
        expect(page).to have_selector("h1", text: "Sample App")
      end

      it "should have the right title" do
        visit static_pages_home_path
        # expect(page).to have_selector("title", 
        #   text: "Ruby on Rails Tutorial Sample App | Home")
        expect(page).to have_title("Ruby on Rails Tutorial Sample App | Home")
      end
    end  

    describe "Help page" do
      it "should have the h1 'Help'" do
        visit static_pages_help_path
        expect(page).to have_selector("h1", "Help")
      end

      it "should have the right title" do
        visit static_pages_help_path
        expect(page).to have_title("Ruby on Rails Tutorial Sample App | Help")
      end
    end

    describe "About page" do
      it "should have the h1 'About Us'" do
        visit static_pages_about_path
        expect(page).to have_selector("h1", "About Us")
      end

      it "should have the right title" do
        visit static_pages_about_path
        expect(page).to have_title("Ruby on Rails Tutorial Sample App | About Us")
      end      
    end

    describe "Content page" do
      it "should have the h1 'Contact'" do
        visit static_pages_contact_path
        expect(page).to have_selector("h1", text: "Contact")
      end

      it "should have the right title" do
        visit static_pages_contact_path
        expect(page).to have_title("Ruby on Rails Tutorial Sample App | Contact")
      end
    end
  end
end