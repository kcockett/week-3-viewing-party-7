Rails.application.routes.draw do
  root 'welcome#index'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'
  get '/users/:id/movies', to: 'movies#index', as: 'movies'
  get '/users/:user_id/movies/:id', to: 'movies#show', as: 'movie'
  get "/login", to: "users#login_form"
	post "/login", to: "users#login_user"
  get "/logout", to: "users#logout"
  get "/dashboard", to: "users#show"
  get "/movies/dummy_show_page", to: "movies#dummy_show"
  get "/movies/dummy_create_party", to: "movies#dummy_create_party"

  resources :users, only: :show
end
