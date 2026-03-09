class Pokemon < ApplicationRecord
  # has_many means one pokemon can have many pokeballs (many trainers can catch the same pokemon)
  has_many :pokeballs

  # has_one_attached is provided by Active Storage — it lets you attach a single image file to this record
  has_one_attached :photo

  # validates makes sure a pokemon can't be saved to the database without a name
  validates :name, presence: true

  # This is a custom instance method — it builds the URL for the pokemon's cry sound
  # #{api_id} is string interpolation: it inserts the value of api_id into the URL
  def cry_url
    "https://raw.githubusercontent.com/PokeAPI/cries/main/cries/pokemon/latest/#{api_id}.ogg"
  end
end
