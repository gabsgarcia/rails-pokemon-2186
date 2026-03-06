Rails.application.routes.draw do
  root to: "pokemons#index"

  resources :pokemons, only: [:show] do
    resources :pokeballs, only: [:create]
    collection do
      get :random
      get :autocomplete   # GET /pokemons/autocomplete?query=pik
    end
  end

  resources :trainers, only: [:index, :show, :new, :create]
  resources :pokeballs, only: [:destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
