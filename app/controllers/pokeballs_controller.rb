class PokeballsController < ApplicationController

  # create handles the "throw pokeball" form — POST /pokemons/:pokemon_id/pokeballs
  def create
    # Find the pokemon we're trying to catch using the :pokemon_id in the URL
    @pokemon = Pokemon.find(params[:pokemon_id])
    # Build a new pokeball from the form data (trainer, location, date)
    @pokeball = Pokeball.new(pokeball_params)
    # Link this pokeball to the pokemon we found above
    @pokeball.pokemon = @pokemon

    # Simulate a 50/50 catch chance — rand(1..2) returns either 1 or 2 randomly
    random_chance = rand(1..2)

    if random_chance == 1
      # Pokeball landed! Save to the database and redirect to the trainer's page
      @pokeball.save
      redirect_to trainer_path(@pokeball.trainer), notice: "You caught #{@pokemon.name}!"
    else
      # Missed! Don't save anything — show the pokemon page again with an alert message
      # flash.now only lasts for THIS render (not a redirect)
      flash.now[:alert] = "Your pokeball missed, try again"
      # status: :unprocessable_entity (HTTP 422) tells Turbo the action did not succeed
      render "pokemons/show", status: :unprocessable_entity
    end
  end

  # destroy releases a pokemon — DELETE /pokeballs/:id
  def destroy
    @pokeball = Pokeball.find(params[:id])
    # Remove the pokeball record from the database (the pokemon still exists, just freed)
    @pokeball.destroy
    # Redirect back to the trainer's page after releasing
    redirect_to trainer_path(@pokeball.trainer),
    notice: :"oh that pokemon is gone",
    status: :see_other  # HTTP 303 — required after DELETE so the browser does a GET redirect
  end

  # private section — only used internally by this controller
  private

  # Strong parameters for pokeball — only allow these three fields from the form
  def pokeball_params
    params.require(:pokeball).permit(:trainer_id, :location, :caught_on)
  end
end
