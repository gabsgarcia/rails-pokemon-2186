class TrainersController < ApplicationController

  # index lists all trainers
  def index
    @trainers = Trainer.all
  end

  # show displays one trainer's profile page
  def show
    # params[:id] comes from the URL — e.g. /trainers/3 → id = 3
    @trainer = Trainer.find(params[:id])
  end

  # new renders the blank sign-up form
  def new
    # We need an empty Trainer object so the form_with helper knows what fields to build
    @trainer = Trainer.new
  end

  # create handles the form submission (POST /trainers)
  def create
    # Build a new trainer from the permitted params (see trainer_params below)
    @trainer = Trainer.new(trainer_params)

    if @trainer.save
      # .save returns true if the record was saved successfully
      # redirect_to @trainer goes to the trainer's show page (Rails figures out the URL automatically)
      redirect_to @trainer, notice: "Welcome back. Time to see your pokemons"
    else
      # If validation fails, re-render the form so the user can fix their input
      # status: :unprocessable_entity tells the browser the form had errors (HTTP 422)
      render :new, status: :unprocessable_entity
    end
  end

  # private methods below are only accessible inside this controller
  private

  # Strong parameters — whitelist exactly which fields a user is allowed to submit
  # This prevents attackers from injecting extra fields (mass assignment protection)
  def trainer_params
    params.require(:trainer).permit(:name, :age, :photo)
  end
end
