class TrainersController < ApplicationController
  def index
    @trainers = Trainer.all
  end

  def show
    @trainer = Trainer.find(params[:id])
  end

  # Optional 1: new trainer form
  def new
    @trainer = Trainer.new
  end

  # Optional 1: create trainer
  def create
    @trainer = Trainer.new(trainer_params)
    if @trainer.save
      redirect_to @trainer, notice: "Welcome, #{@trainer.name}! Time to catch 'em all!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def trainer_params
    params.require(:trainer).permit(:name, :age, :photo)
  end
end
