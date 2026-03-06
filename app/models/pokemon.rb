class Pokemon < ApplicationRecord
  has_many :pokeballs
  validates :name, presence: true
  has_one_attached :photo

  def cry_url
    "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/#{api_id}.ogg"
  end
end
