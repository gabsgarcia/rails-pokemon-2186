# rails g model Pokeball trainer:references pokemon:references location:string caught_on:date

class CreatePokeballs < ActiveRecord::Migration[7.1]
  def change
    create_table :pokeballs do |t|
      # references creates a trainer_id integer column + a foreign key constraint
      # null: false means every pokeball must belong to a trainer (can't be orphaned)
      t.references :trainer, null: false, foreign_key: true

      # same as above — every pokeball must be linked to a pokémon
      t.references :pokemon, null: false, foreign_key: true

      t.string :location  # where the pokémon was caught, e.g. "Viridian Forest"
      t.date :caught_on   # the date the pokémon was caught

      t.timestamps # adds created_at and updated_at columns automatically
    end
  end
end
