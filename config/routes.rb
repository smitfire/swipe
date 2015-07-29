Rails.application.routes.draw do
  resources :books
  # devise_for :users
  # root to: "home#index"
  root "high_voltage/pages#show", id: 'home'
  devise_for :users, controllers: { sessions: "users/sessions" }
  resources :users
  get "/users/:id/matches" => "users#matches", as: :user_matches 
  get "/users/:id/stack" => "users#stack", as: :user_stack

  get "/users/:id/stack/:book_id/like" => "users#like", as: :user_like
  get "/users/:id/stack/:book_id/dislike" => "users#dislike", as: :user_dislike

end
