# rails g model Pokemon name:string element_type:string api_id:integer

class CreatePokemons < ActiveRecord::Migration[7.1]
  def change
    create_table :pokemons do |t|
      t.string :name         # the pokémon's display name, e.g. "Pikachu"
      t.string :element_type # the pokémon's type, e.g. "Electric", "Fire", "Water"
      t.integer :api_id      # the ID from the PokéAPI — lets us fetch extra data from the external API

      t.timestamps # adds created_at and updated_at columns automatically
    end
  end
end
