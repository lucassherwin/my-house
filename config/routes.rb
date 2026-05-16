Rails.application.routes.draw do
  get "hello_world", to: "hello_world#index"
  get "up" => "rails/health#show", as: :rails_health_check

  get    "/login",  to: "sessions#new",       as: :login
  post   "/login",  to: "sessions#create"
  delete "/logout", to: "sessions#destroy",   as: :logout

  get  "/signup", to: "registrations#new",   as: :signup
  post "/signup", to: "registrations#create"

  root to: "home#index"
end
