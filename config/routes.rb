Rails.application.routes.draw do
  devise_for :users

  root "meeting_minutes#index"

  resources :meeting_minutes
  resources :employees

  namespace :admin do
    get "dashboard", to: "dashboard#index"
    resources :positions, except: [:show]
  end

  get "up" => "rails/health#show", as: :rails_health_check
end
