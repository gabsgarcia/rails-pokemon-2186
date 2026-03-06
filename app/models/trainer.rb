class Trainer < ApplicationRecord
  has_many :pokeballs
  has_many :pokemons, through: :pokeballs
  validates :name, presence: true
  has_one_attached :photo
end
