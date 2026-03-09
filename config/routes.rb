Rails.application.routes.draw do
  # ============================================
  # You'll build these routes during the lecture!
  # ============================================
  # root to: "pages#home"  ← the default placeholder before we set our own

  # Step 1 — set the root route
  # root is the homepage — visiting "/" will call PokemonsController#index
  root to: "pokemons#index"

  # Step 2 — pokemon routes (show only + nested pokeballs + collection actions)
  # resources generates RESTful routes automatically — only: limits which ones are created
  # verb "path", to: "controller#action"
  resources :pokemons, only: [:show] do
    # Nested resource — pokeballs are created INSIDE a pokemon's URL context
    # This gives us POST /pokemons/:pokemon_id/pokeballs → PokeballsController#create
    resources :pokeballs, only: [:create] # POST /pokemons/pokemon_id/pokeballs

    # collection routes belong to the whole collection (no :id needed)
    collection do
      get :random      # GET /pokemons/random → PokemonsController#random
      get :autocomplete # GET /pokemons/autocomplete → PokemonsController#autocomplete (used by the search JS)
    end
  end

  # Step 3 — trainer routes
  # We don't need edit/update/destroy for trainers in this app, so we limit to these 4
  resources :trainers, only: [:index, :show, :new, :create]

  # Step 4 — standalone pokeball destroy
  # We need DELETE /pokeballs/:id separately (outside the pokemon nesting) so we can destroy from the trainer page
  resources :pokeballs, only: [:destroy]

  # Built-in Rails health check endpoint — used by deployment platforms to verify the app is running
  get "up" => "rails/health#show", as: :rails_health_check
end
