require 'json'
require 'open-uri'

puts "Cleaning database..."
# Destroy in order — foreign key constraints!
Pokeball.destroy_all
Trainer.destroy_all
Pokemon.destroy_all

puts "Creating trainers..."

ash = Trainer.create!(name: "Ash Ketchum", age: 18)
ash.photo.attach(
  io: URI.parse("https://upload.wikimedia.org/wikipedia/en/e/e4/Ash_Ketchum_Journeys.png").open,
  filename: "ash_ketchum.png",
  content_type: "image/png"
)
puts "  ✓ Ash has stepped up to the plate!"

misty = Trainer.create!(name: "Misty", age: 20)
misty.photo.attach(
  io: URI.parse("https://upload.wikimedia.org/wikipedia/en/b/b1/MistyEP.png").open,
  filename: "misty.png",
  content_type: "image/png"
)
puts "  ✓ Misty is ready to go!"

brock = Trainer.create!(name: "Brock", age: 22)
brock.photo.attach(
  io: URI.parse("https://upload.wikimedia.org/wikipedia/en/7/71/DP-Brock.png").open,
  filename: "brock.png",
  content_type: "image/png"
)
puts "  ✓ Brock is on the scene!"

puts "\nCreating Pokémon from PokéAPI..."
response = URI.parse("https://pokeapi.co/api/v2/pokemon?limit=100").read
results = JSON.parse(response)["results"]

results.each do |result|
  info = JSON.parse(URI.parse(result["url"]).read)
  pokemon = Pokemon.create!(
    name: info["name"].capitalize,
    element_type: info["types"].first["type"]["name"],
    api_id: info["id"]
  )
  pokemon.photo.attach(
    io: URI.parse(info["sprites"]["front_default"]).open,
    filename: "#{info['name']}.png",
    content_type: "image/png"
  )
  puts "  ✓ #{pokemon.name} (#{pokemon.element_type})"
end

puts "\nCreating pokéballs..."

Trainer.all.each do |trainer|
  Pokemon.all.sample(3).each do |pokemon|
    Pokeball.create!(
      trainer: trainer,
      pokemon: pokemon,
      caught_on: Date.today,
      location: Pokeball::TOWNS.sample
    )
    puts "  ✓ #{trainer.name} caught #{pokemon.name}!"
  end
end

puts "\n✅ Done!"
puts "   #{Trainer.count} trainers"
puts "   #{Pokemon.count} pokémon"
puts "   #{Pokeball.count} pokéballs"
