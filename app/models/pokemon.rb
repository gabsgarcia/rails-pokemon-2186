class Pokemon < ApplicationRecord
  
  # assoriations
  has_many :pokeballs
  has_one_attached :photo 
  # validations
  validates :name, presence: true

  def cry_url
    "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/#{api_id}.ogg"
  end
end
