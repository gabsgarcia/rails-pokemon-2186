class Trainer < ApplicationRecord
  # A trainer can own many pokeballs (each pokeball represents a caught pokemon)
  has_many :pokeballs

  # has_many :through lets us skip the join table — trainer.pokemons gives us all caught pokemons directly
  # It goes: Trainer → Pokeball → Pokemon
  has_many :pokemons, through: :pokeballs

  # Active Storage attachment — lets trainers have a profile photo
  has_one_attached :photo

  # A trainer must have a name before being saved
  validates :name, presence: true
end
