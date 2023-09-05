require 'rails_helper'

RSpec.describe "User Registration" do
  it 'can create a user with a name and unique email' do
    # ***Authentication Challenge, US1 ***
    # As a visitor 
    # When I visit `/register`
    # I see a form to fill in my name, email, password, and password confirmation.
    # When I fill in that form with my name, email, and matching passwords,
    # I'm taken to my dashboard page `/users/:id`

    visit register_path

    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with:'Password'
    fill_in :user_password_confirmation, with:'Password'
    click_button 'Create New User'
    
    expect(current_path).to eq(user_path(User.last.id))
    expect(page).to have_content("User One's Dashboard")
  end 

  it 'does not create a user if email isnt unique' do 
    User.create(name: 'User One', email: 'notunique@example.com', password: "password", password_confirmation: "password")

    visit register_path
    
    fill_in :user_name, with: 'User Two'
    fill_in :user_email, with:'notunique@example.com'
    fill_in :user_password, with:'Password'
    fill_in :user_password_confirmation, with:'Password'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email has already been taken")
  end

  it "SAD PATH - missing name" do
    # ***Authentication Challenge, US1 ***
    # As a visitor 
    # When I visit `/register`
    # and I fail to fill in my name, unique email, OR matching passwords,
    # I'm taken back to the `/register` page
    # and a flash message pops up, telling me what went wrong

    visit register_path
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with:'Password'
    fill_in :user_password_confirmation, with:'Password'
    click_button 'Create New User'
    
    expect(current_path).to eq(register_path)
    expect(page).to have_content("Name can't be blank")
  end
  
  it "SAD PATH - missing email" do
    visit register_path
    fill_in :user_name, with: 'User One'
    fill_in :user_password, with:'Password'
    fill_in :user_password_confirmation, with:'Password'
    click_button 'Create New User'
    
    expect(current_path).to eq(register_path)
    expect(page).to have_content("Email can't be blank")
  end
  
  it "SAD PATH - non-matching passwords" do
    visit register_path
    fill_in :user_name, with: 'User One'
    fill_in :user_email, with:'user1@example.com'
    fill_in :user_password, with:'Password'
    fill_in :user_password_confirmation, with:'NotPassword'
    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
