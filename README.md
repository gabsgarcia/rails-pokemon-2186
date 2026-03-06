# ⚡ Pokémon Rails

> A Ruby on Rails MVC application built during the Le Wagon Rails Reboot lecture.
> Gotta catch 'em all — with a Pokédex, trainers, and a 50% catch rate!

![Ruby](https://img.shields.io/badge/Ruby-3.3.5-red?style=flat-square&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-7.1-cc0000?style=flat-square&logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-blue?style=flat-square&logo=postgresql)

---

## 📖 What This App Does

- Browse a **Pokédex** of 50 Pokémon fetched from the [PokéAPI](https://pokeapi.co/)
- **Search** for a Pokémon by name with autocomplete
- View a **random Pokémon** from the collection
- **Create trainers** with a name, age, and photo
- **Catch Pokémon** — but watch out, there's a 50% chance you'll miss!
- **Release Pokémon** back into the wild from a trainer's profile

---

## 🗂️ Models & Associations

```
Trainer ──< Pokeball >── Pokemon
```

| Model | Associations |
|---|---|
| `Pokemon` | `has_many :pokeballs` |
| `Trainer` | `has_many :pokeballs`, `has_many :pokemons, through: :pokeballs` |
| `Pokeball` | `belongs_to :trainer`, `belongs_to :pokemon` |

### Database Schema

```
trainers        pokemons          pokeballs
─────────       ─────────         ─────────────────
id              id                id
name            name              trainer_id  (FK)
age             element_type      pokemon_id  (FK)
timestamps      api_id            location
                timestamps        caught_on
                                  timestamps
```

---

## 🛣️ Routes

```
GET    /                          → pokemons#index
GET    /pokemons/:id              → pokemons#show
GET    /pokemons/random           → pokemons#random
GET    /pokemons/autocomplete     → pokemons#autocomplete (JSON)
POST   /pokemons/:pokemon_id/pokeballs  → pokeballs#create
DELETE /pokeballs/:id             → pokeballs#destroy

GET    /trainers                  → trainers#index
GET    /trainers/:id              → trainers#show
GET    /trainers/new              → trainers#new
POST   /trainers                  → trainers#create
```

---

## 🚀 Getting Started

### Prerequisites

Make sure you have these installed:

- Ruby `3.3.5` — check with `ruby -v`
- Rails `7.1` — check with `rails -v`
- PostgreSQL — check with `psql --version`
- A [Cloudinary](https://cloudinary.com/) account (free tier is fine)

### 1. Clone the repository

```bash
git clone git@github.com:YOUR_USERNAME/rails-pokemon.git
cd rails-pokemon
```

### 2. Install dependencies

```bash
bundle install
```

> If you get a gem version conflict error, run:
> ```bash
> bundle update error_highlight
> ```

### 3. Set up environment variables

Create a `.env` file at the root of the project:

```bash
touch .env
```

Add your Cloudinary URL — find it in your Cloudinary dashboard:

```
CLOUDINARY_URL=cloudinary://your_api_key:your_api_secret@your_cloud_name
```

> ⚠️ The `.env` file is in `.gitignore` — it should **never** be committed to GitHub.

### 4. Set up the database

```bash
rails db:create
rails db:migrate
rails db:seed
```

> The seed file fetches 50 Pokémon from the PokéAPI and uploads their sprites to Cloudinary.
> This may take a couple of minutes — grab a coffee ☕

### 5. Start the server

```bash
rails server
```

Open [http://localhost:3000](http://localhost:3000) in your browser.

---

## 📁 File Structure

Key files to study:

```
app/
├── controllers/
│   ├── pokemons_controller.rb     ← index, show, random, autocomplete
│   ├── trainers_controller.rb     ← index, show, new, create
│   └── pokeballs_controller.rb    ← create (catch!), destroy (release)
│
├── models/
│   ├── pokemon.rb                 ← has_many, has_one_attached, cry_url
│   ├── trainer.rb                 ← has_many :through, validates
│   └── pokeball.rb                ← belongs_to x2, TOWNS constant
│
├── views/
│   ├── layouts/
│   │   └── application.html.erb   ← navbar, flashes, yield
│   ├── shared/
│   │   └── _flashes.html.erb      ← notice/alert flash messages
│   ├── pokemons/
│   │   ├── index.html.erb         ← grid + search form
│   │   ├── show.html.erb          ← pokemon detail + catch form
│   │   └── _pokemon.html.erb      ← pokemon card partial
│   └── trainers/
│       ├── index.html.erb
│       ├── show.html.erb          ← trainer profile + release buttons
│       ├── new.html.erb           ← new trainer form
│       └── _trainer.html.erb      ← trainer card partial
│
├── javascript/
│   └── controllers/
│       └── autocomplete_controller.js  ← Stimulus autocomplete
│
└── assets/stylesheets/
    ├── application.scss           ← import order matters!
    ├── config/
    │   ├── _colors.scss           ← all color variables
    │   ├── _fonts.scss            ← Press Start 2P
    │   └── _bootstrap_variables.scss  ← Bootstrap overrides
    └── components/
        ├── _navbar.scss
        ├── _pokemon_card.scss     ← rainbow hover effect
        ├── _trainer_card.scss
        ├── _alert.scss
        ├── _layout.scss
        └── _autocomplete.scss
```

---

## 🧠 Key Concepts to Study

### `has_many :through`
```ruby
# Trainer can access pokemons without going through Pokeball manually
ash.pokemons  # Rails writes the JOIN SQL for you
```

### Nested routes
```ruby
# pokeballs#create is nested — pokemon_id comes from the URL
resources :pokemons do
  resources :pokeballs, only: [:create]
end
# → POST /pokemons/:pokemon_id/pokeballs
```

### `render` vs `redirect_to`
```ruby
# On failure — render keeps instance variables in memory
flash.now[:alert] = "Missed!"
render "pokemons/show"

# On success — redirect sends a new GET request
redirect_to trainer_path(@trainer), notice: "Caught it!"
```

### `status: :see_other` on destroy
```ruby
# Required in Rails 7 with Turbo after DELETE requests
redirect_to trainer_path(@trainer), status: :see_other
```

### Strong params
```ruby
# Only permitted attributes can be saved — prevents mass assignment attacks
def trainer_params
  params.require(:trainer).permit(:name, :age, :photo)
end
```

### Model constants
```ruby
# Pokeball::TOWNS — accessible in views, controllers, and seeds
TOWNS = ["Vermilion City", "Cerulean City", ...].freeze
```

---

## ✨ Features Breakdown

| Feature | File | Concept |
|---|---|---|
| Random 25 on homepage | `pokemons_controller.rb` | `ORDER BY RANDOM()` + `limit` |
| Search with ILIKE | `pokemons_controller.rb` | SQL injection prevention with `?` |
| Autocomplete dropdown | `autocomplete_controller.js` | Stimulus + fetch + JSON endpoint |
| 50% catch rate | `pokeballs_controller.rb` | `rand`, render vs redirect |
| Release a Pokémon | `trainers/show.html.erb` | `turbo_method: :delete` |
| File uploads | `trainer.rb`, `pokemon.rb` | ActiveStorage + Cloudinary |
| Pokémon cry sound | `pokemon.rb` `#cry_url` | External API asset, `<audio>` tag |
| Rainbow card hover | `_pokemon_card.scss` | CSS `::after`, `hue-rotate` animation |

---

## 🐛 Common Issues

**`Gem::LoadError` — error_highlight version conflict**
```bash
bundle update error_highlight
```

**Cloudinary images not showing**
- Check your `.env` file has `CLOUDINARY_URL`
- Make sure `dotenv-rails` gem is in your Gemfile
- Restart the server after editing `.env`

**Flash messages not appearing**
- Confirm `<%= render "shared/flashes" %>` is in `application.html.erb` above `yield`
- Confirm `import "bootstrap"` is in `application.js`
- Use `flash.now` with `render`, and `flash` (or `notice:`) with `redirect_to`

**`status: :see_other` missing**
- Turbo DELETE redirects need HTTP 303, not 302
- Always add `status: :see_other` to any `redirect_to` inside a `destroy` action

**Seeds fail halfway**
- Re-run `rails db:seed` — the `destroy_all` at the top cleans up and restarts fresh
- Check your internet connection — the seed fetches from the PokéAPI

---

## 📚 Resources

- [PokéAPI](https://pokeapi.co/) — the API used for Pokémon data and sprites
- [Rails Guides — Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [Rails Guides — Routing](https://guides.rubyonrails.org/routing.html)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Cloudinary Rails SDK](https://cloudinary.com/documentation/rails_integration)
- [simple_form docs](https://github.com/heartcombo/simple_form)

---

## 🎓 Built at Le Wagon

This app was built during the **Rails Reboot** lecture as part of the Le Wagon coding bootcamp curriculum. It covers the full MVC cycle, ActiveRecord associations, file uploads, and a touch of Stimulus JS.

*Happy coding! ⚡*
