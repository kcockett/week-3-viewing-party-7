class MoviesController < ApplicationController
  def index 
      @user = User.find(params[:id])
      @movies = Movie.all
  end 

  def show 
      @user = User.find(params[:user_id])
      @movie = Movie.find(params[:id])
  end 

  def dummy_show
    #This is a dummy show page used for our Day 2 Challenge, User Story 4.  This is necessary because the functionality was never added to this respository to be able to create a Viewing Party.
  end

  def dummy_create_party
    #This page should only be accessible to authenticated users.
    if !current_user
      flash[:error] = "You must be logged in or registered to create a movie party."
      redirect_to movies_dummy_show_page_path
    end
  end
end 