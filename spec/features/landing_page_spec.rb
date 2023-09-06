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

  # *** Removed by Challenge2 Pt2 US1 ***
  # it 'lists out existing users' do 
  #   expect(page).to have_content('Existing Users:')
    
  #   within('.existing-users') do 
  #     expect(page).to have_content(@user1.email)
  #     expect(page).to have_content(@user2.email)
  #   end     
  # end 

  describe "*** Authentication Challenge1 US3 ***" do
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
  describe "*** Authentication Challenge1 US4 ***" do
    # As a registered user
    # When I visit the landing page `/`
    # And click on the link to go to my dashboard
    # And fail to fill in my correct credentials 
    # I'm taken back to the Log In page
    # And I can see a flash message telling me that I entered incorrect credentials.
    
    it "should show credential failure" do
      # *** Modified by Challenge2 Pt2 US1 ***
      #click_link "user1@test.com"
      visit login_path
      
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
  describe "*** Authentication Challenge2 Pt1 ***" do
    # As a logged in user 
    # When I visit the landing page
    # I no longer see a link to Log In or Create an Account
    # But I see a link to Log Out.
    # When I click the link to Log Out
    # I'm taken to the landing page
    # And I can see that the Log Out link has changed back to a Log In link

    it "should have a link to 'Log Out' which takes me to the landing page" do
      visit login_path
      fill_in :email, with: @user1.email
      fill_in :password, with: "password"
      click_on "Log In"
      visit root_path

      expect(page).to_not have_link('Log In')
      expect(page).to_not have_link('Create New User')
      expect(page).to have_link('Log Out')
      
      click_link "Log Out"
      
      expect(current_path).to eq root_path
      expect(page).to have_link('Log In')
      expect(page).to have_button('Create New User')
      expect(page).to_not have_link('Log Out')
    end
  end
  describe "*** Authentication Challenge2 Pt2 ***" do
    it "US1 As a visitor When I visit the landing page I do not see the section of the page that lists existing users" do
      visit root_path
      expect(page).to_not have_content('Existing Users:')
    end
    it "US2 As a registered user, When I visit the landing page,The list of existing users is no longer a link to their show pages
    But just a list of email addresses" do
      visit login_path
      fill_in :email, with: @user1.email
      fill_in :password, with: "password"
      click_on "Log In"
      visit root_path
      # user is now logged in

      expect(page).to have_content('Existing Users:')
      within ".existing-users" do
        expect(page).not_to have_css('a')
      end
    end
    it "US3 As a visitor, When I visit the landing page, And then try to visit '/dashboard', I remain on the landing page, And I see a message telling me that I must be logged in or registered to access my dashboard" do
      visit root_path
      visit "/dashboard"

      expect(current_path).to eq root_path
      expect(page).to have_content("You must be logged in or registered to access your dashboard.")
    end
  end
end
