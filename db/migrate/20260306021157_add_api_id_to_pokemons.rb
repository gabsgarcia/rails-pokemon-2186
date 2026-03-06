class AddApiIdToPokemons < ActiveRecord::Migration[7.1]
  def change
    add_column :pokemons, :api_id, :integer
  end
end
