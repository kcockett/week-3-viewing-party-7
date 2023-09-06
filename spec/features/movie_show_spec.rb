require 'rails_helper'

RSpec.describe 'Movies Show Page' do
  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: "password", password_confirmation: "password")
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
    end 
  end 

  it 'shows all movies' do 
    # Log in the user
    visit login_path
    fill_in :email, with: @user1.email
    fill_in :password, with: "password"
    click_on "Log In"
    # redirects to the user dashboard

    click_button "Find Top Rated Movies"

    expect(current_path).to eq("/users/#{@user1.id}/movies")

    expect(page).to have_content("Top Rated Movies")
    
    movie_1 = Movie.first

    click_link(movie_1.title)

    expect(current_path).to eq("/users/#{@user1.id}/movies/#{movie_1.id}")

    expect(page).to have_content(movie_1.title)
    expect(page).to have_content(movie_1.description)
    expect(page).to have_content(movie_1.rating)
  end 

  describe "*** Authentication Challenge2 Pt2 ***" do
    it "US4 As a visitor, If I go to a movies show page, And click the button to create a viewing party, I'm redirected to the movies show page, and a message appears to let me know I must be logged in or registered to create a movie party." do
      visit movie_path(User.first, Movie.first)
      save_and_open_page
      click_button "Create Viewing Party"

      expect(current_path).to eq movie_path(User.first, Movie.first)
      expect(page).to have_content("You must be logged in or registered to create a movie party.")
    end
  end
end