class CreatePokemons < ActiveRecord::Migration[7.1]
  def change
    create_table :pokemons do |t|
      t.string :name
      t.string :element_type
      t.integer :api_id

      t.timestamps
    end
  end
end
