require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    @user1 = User.create!(name: "User One", email: "user1@test.com", password: "password", password_confirmation: "password")
    @user2 = User.create!(name: "User Two", email: "user2@test.com", password: "password", password_confirmation: "password")
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    expect(page).to have_content('Existing Users:')
    
    within('.existing-users') do 
      expect(page).to have_content(@user1.email)
      expect(page).to have_content(@user2.email)
    end     
  end 

  describe "*** Authentication Challenge US3 ***" do
    # As a registered user
    # When I visit the landing page `/`
    # I see a link for "Log In"
    # When I click on "Log In"
    # I'm taken to a Log In page ('/login') where I can input my unique email and password.
    # When I enter my unique email and correct password 
    # I'm taken to my dashboard page

    it "should have a link to 'Log In' which takes me to login page" do
      visit root_path

      expect(page).to have_link('Log In')
      click_link "Log In"
      expect(current_path).to eq login_path
    end

    it "have a login form which verifies the user and redirects to Dashboard page" do
      visit login_path
      fill_in :email, with: @user1.email
      fill_in :password, with: "password"
      click_on "Log In"
      
      expect(current_path).to eq user_path(@user1.id)
    end
  end
  describe "*** Authentication Challenge US4 ***" do
    # As a registered user
    # When I visit the landing page `/`
    # And click on the link to go to my dashboard
    # And fail to fill in my correct credentials 
    # I'm taken back to the Log In page
    # And I can see a flash message telling me that I entered incorrect credentials.

    it "should show credential failure" do
      click_link "user1@test.com"

      expect(current_path).to eq login_path

      fill_in :email, with: @user1.email
      fill_in :password, with: "WrongPassword"
      click_button "Log In"

      expect(current_path).to eq login_path
      expect(page).to have_content("Sorry, your credentials are bad.")

      fill_in :email, with: "IncorrectEmail@test.com"
      fill_in :password, with: "password"
      click_button "Log In"

      expect(current_path).to eq login_path
      expect(page).to have_content("Sorry, your credentials are bad.")

      # omit email
      fill_in :password, with: "WrongPassword"
      click_button "Log In"

      expect(current_path).to eq login_path
      expect(page).to have_content("Sorry, your credentials are bad.")

      fill_in :email, with: @user1.email
      # omit password
      click_button "Log In"

      expect(current_path).to eq login_path
      expect(page).to have_content("Sorry, your credentials are bad.")
    end
  end
end
