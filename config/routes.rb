Rails.application.routes.draw do
  # ============================================
  # You'll build these routes during the lecture!
  # ============================================
  # root to: "pages#home"

  # Step 1 — set the root route
  root to: "pokemons#index"

  # Step 2 — pokemon routes (show only + nested pokeballs + collection actions)
  # verb "path", to: "controller#action"
  resources :pokemons, only: [:show] do
    resources :pokeballs, only: [:create] # POST /pokemons/:pokemon_id/pokeballs
    collection do
      get :random # GET/pokemons/random
      get :autocomplete #GET/pokemons/autocomplete?query=input
    end
  end

  # Step 3 — trainer routes
  resources :trainers, only: [:index, :show, :new, :create]
  
  # Step 4 — standalone pokeball destroy
  resources :pokeballs, only: [:destroy]

  get "up" => "rails/health#show", as: :rails_health_check
end
