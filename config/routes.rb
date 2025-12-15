Rails.application.routes.draw do
  # Health check endpoint
  get "up" => "rails/health#show", as: :rails_health_check

  # API routes only
  namespace :api do
      resources :voice_generations, only: [:create, :show, :index]
    end
end