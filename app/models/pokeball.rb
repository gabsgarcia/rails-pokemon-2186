class Pokeball < ApplicationRecord
  belongs_to :pokemon
  belongs_to :trainer

  TOWNS = [
    "Vermilion City", "Cerulean City", "Pewter City",
    "Saffron City", "Celadon City", "Cinnabar Island", "Fuchsia City"
  ].freeze
end
