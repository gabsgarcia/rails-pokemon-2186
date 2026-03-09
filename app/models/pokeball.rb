class Pokeball < ApplicationRecord
  # belongs_to means this model holds the foreign key — a pokeball must belong to a trainer AND a pokemon
  # In the database there are columns: trainer_id and pokemon_id
  belongs_to :trainer
  belongs_to :pokemon

  # A Ruby constant (ALL_CAPS) — a list of Pokémon town names used as location options
  # .freeze makes the array immutable so nobody accidentally changes it at runtime
  TOWNS = [
    "Vermilion City", "Cerulean City", "Pewter City",
    "Saffron City", "Celadon City", "Cinnabar Island", "Fuchsia City"
  ].freeze
end
