class PokemonsController < ApplicationController
  def index
    # Optional 2: search bar
    if params[:search]
      @pokemons = Pokemon.where("name ILIKE ?", "%#{params[:search]}%")
    else
      @pokemons = Pokemon.order("RANDOM()").limit(35)
    end
  end

  # Returns JSON list of names for autocomplete
  # GET /pokemons/autocomplete?query=pik
  def autocomplete
    names = Pokemon
      .where("name ILIKE ?", "%#{params[:query]}%")
      .order(:name)
      .limit(8)
      .pluck(:name)   # just the names, no full objects

    render json: names
  end

  def show
    @pokemon = Pokemon.find(params[:id])
    @pokeball = Pokeball.new(pokemon: @pokemon, caught_on: Date.today)
  end

  # Optional 4: random pokemon
  def random
    @pokemon = Pokemon.order("RANDOM()").first
    @pokeball = Pokeball.new(pokemon: @pokemon, caught_on: Date.today)
    render :show
  end
end
