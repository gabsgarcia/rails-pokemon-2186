class PokemonsController < ApplicationController

  # index is the listing page — shows all (or filtered) pokémons
  def index
    # If a search param is present in the URL (e.g. ?search=Pikachu), filter by name
    # ILIKE is a case-insensitive LIKE in PostgreSQL — the % wildcards match any characters around the search term
    # @pokemons = Pokemon.all  ← old version: fetched every single row (can be thousands!)
    if params[:search]
      @pokemons = Pokemon.where("name ILIKE ?", "%#{params[:search]}%")
    else
      # No search? Show 35 random pokémons so the page always feels fresh
      @pokemons = Pokemon.order("RANDOM()").limit(35)
    end
  end

  # show displays a single pokémon's detail page
  def show
    # params[:id] comes from the URL, e.g. /pokemons/25 → id = 25
    @pokemon = Pokemon.find(params[:id])
    # Pre-build an empty pokeball so the catch form on this page has an object to work with
    # caught_on defaults to today so the user doesn't have to pick a date manually
    @pokeball = Pokeball.new(pokemon: @pokeball, caught_on: Date.today)
  end

  # random picks a surprise pokémon and reuses the show view
  def random
    @pokemon = Pokemon.order("RANDOM()").first
    @pokeball = Pokeball.new(pokemon: @pokemon, caught_on: Date.today)
    # render :show tells Rails to display app/views/pokemons/show.html.erb instead of random.html.erb
    render :show
  end

  # autocomplete is a JSON-only endpoint — no HTML view, no layout
  # It is triggered by a JavaScript fetch/AJAX call every time the user types a character in the search box
  # Route example: GET /pokemons/autocomplete?query=char  →  ["Charizard", "Charmeleon", "Charmander"]
  def autocomplete
    names = Pokemon
      # ILIKE is PostgreSQL's case-insensitive LIKE
      # The % on both sides means "anything before AND after the query string"
      # params[:query] is the text the user has typed so far, passed as a URL parameter (?query=...)
      # The ? placeholder (not string interpolation) protects against SQL injection
      .where("name ILIKE ?", "%#{params[:query]}%")
      # Sort alphabetically so the dropdown list looks clean and predictable
      .order(:name)
      # Cap results at 8 — enough to be helpful without overwhelming the dropdown UI
      .limit(8)
      # .pluck returns a plain Ruby Array of that one column's values, e.g. ["Bulbasaur", "Butterfree"]
      # It is faster than .map(&:name) because it skips instantiating full ActiveRecord objects
      .pluck(:name)

    # render json: converts the Ruby array to a JSON string and sets Content-Type: application/json
    # The JavaScript on the front-end reads this array and renders the suggestion list
    render json: names
  end
end
