class Pokeball < ApplicationRecord
  belongs_to :trainer
  belongs_to :pokemon

   TOWNS = [
    "Vermilion City", "Cerulean City", "Pewter City",
    "Saffron City", "Celadon City", "Cinnabar Island", "Fuchsia City"
  ].freeze
end
