# ⚡ Pokémon Rails

> A Ruby on Rails MVC application built during the Le Wagon Rails Reboot lecture.
> Gotta catch 'em all — with a Pokédex, trainers, and a 50% catch rate!

![Ruby](https://img.shields.io/badge/Ruby-3.3.5-red?style=flat-square&logo=ruby)
![Rails](https://img.shields.io/badge/Rails-7.1-cc0000?style=flat-square&logo=rubyonrails)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-blue?style=flat-square&logo=postgresql)

---

## 📖 What This App Does

- Browse a **Pokédex** of 100 Pokémon fetched from the [PokéAPI](https://pokeapi.co/)
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

> The seed file fetches 100 Pokémon from the PokéAPI and uploads their sprites to Cloudinary.
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
│   │   └── application.html.erb   ← navbar, footer, flashes, yield
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
    │   ├── _colors.scss           ← all color variables + type colors
    │   ├── _fonts.scss            ← Press Start 2P (Google Fonts)
    │   └── _bootstrap_variables.scss  ← Bootstrap overrides (theme, colors, fonts)
    ├── components/
    │   ├── _index.scss            ← barrel file, imports all components
    │   ├── _navbar.scss
    │   ├── _pokemon_card.scss     ← rainbow hover effect
    │   ├── _trainer_card.scss
    │   ├── _alert.scss
    │   ├── _layout.scss
    │   └── _autocomplete.scss
    └── pages/
        ├── _index.scss            ← barrel file, imports all pages
        └── _home.scss             ← home-page specific styles
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
| Random 35 on homepage | `pokemons_controller.rb` | `ORDER BY RANDOM()` + `limit` |
| Search with ILIKE | `pokemons_controller.rb` | SQL injection prevention with `?` |
| Autocomplete dropdown | `autocomplete_controller.js` | Stimulus + fetch + JSON endpoint |
| 50% catch rate | `pokeballs_controller.rb` | `rand`, render vs redirect |
| Release a Pokémon | `trainers/show.html.erb` | `turbo_method: :delete` |
| File uploads | `trainer.rb`, `pokemon.rb` | ActiveStorage + Cloudinary |
| Pokémon cry sound | `pokemon.rb` `#cry_url` | External API asset, `<audio>` tag |
| Rainbow card hover | `_pokemon_card.scss` | CSS `::after`, `hue-rotate` animation |
| Type badges | `_pokemon.html.erb`, `_pokemon_card.scss` | Data-driven CSS classes |
| Font Awesome icons | views, `application.scss` | `fa-solid`, `fa-brands`, `fa-bounce` |
| Footer with links | `application.html.erb`, `_layout.scss` | Semantic `<footer>`, FA animations |

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

## 🎨 Front-end

### Tech Stack

| Tool | Version | Role |
|---|---|---|
| Bootstrap | `~> 5.3` | Grid, components, utilities |
| Font Awesome | `~> 6.1` (font-awesome-sass) | Icons |
| Press Start 2P | Google Fonts | Pixel-art heading font |
| SCSS | via `sassc-rails` | Custom styles, variables, nesting |

### SCSS Architecture

The import order in `application.scss` is critical — Bootstrap reads your variables before compiling:

```scss
// 1. Our config (variables must come first)
@import "config/fonts";              // Google Fonts + $body-font / $headers-font
@import "config/colors";             // $darkbg, $pokeyellow, $cardbg, type colors…
@import "config/bootstrap_variables"; // overrides Bootstrap defaults using our vars

// 2. External libraries (reads our overrides)
@import "bootstrap";
@import "font-awesome";

// 3. Our components and pages (sit on top of Bootstrap)
@import "components/index";
@import "pages/index";
```

### Dark Pokédex Theme

Bootstrap's defaults are overridden in `_bootstrap_variables.scss` before the library is imported:

```scss
$body-bg:    $darkbg;       // #0D1117 — near-black background
$body-color: $white;
$primary:    $pokeyellow;   // #FFCB05 — Pokémon yellow as Bootstrap primary
$card-bg:    $cardbg;       // #161B22 — dark card background
```

Global base styles in `application.scss` also apply dark theming to all `simple_form` inputs (`.form-control`, `.form-select`) so they match the dark card aesthetic.

### Color Palette

All colors are defined as SCSS variables in `_colors.scss`:

```scss
// Dark backgrounds
$darkbg:     #0D1117;   // page background
$cardbg:     #161B22;   // card / input background
$cardedge:   #21262D;   // subtle card border

// Brand
$pokered:    #E3350D;
$pokeyellow: #FFCB05;   // mapped to Bootstrap $primary
$pokeblue:   #003A70;

// Pokémon type badge colors (matches PokéAPI element_type strings)
$type-normal:   #ADB5BD;
$type-fire:     #FFA657;
$type-water:    #58A6FF;
$type-electric: #F9D22E;
$type-grass:    #7EE787;
$type-ice:      #98D8D8;
$type-fighting: #C03028;
$type-poison:   #A040A0;
$type-ground:   #E0C068;
$type-flying:   #A890F0;
$type-psychic:  #D87BF4;
$type-bug:      #A8C820;
$type-rock:     #B8A038;
$type-ghost:    #705898;
$type-dragon:   #7038F8;
```

### Typography

Both body text and headings use **Press Start 2P** (the retro pixel font) imported from Google Fonts. Heading sizes are fluid using `clamp()` so they scale with the viewport:

```scss
h1 { font-size: clamp(0.8rem, 2.5vw, 1.2rem); }
h2 { font-size: clamp(0.7rem, 2vw, 1rem); }
```

### Font Awesome Icons

Font Awesome is installed as a gem (`font-awesome-sass`) and imported in `application.scss`. That's all the setup needed — no CDN, no manual download.

#### Icon syntax

Every icon is an `<i>` tag with two classes: the **family** and the **icon name**:

```html
<!-- Solid family (most common) -->
<i class="fa-solid fa-dice"></i>

<!-- Brands family (logos like GitHub, Font Awesome) -->
<i class="fa-brands fa-font-awesome"></i>

<!-- Regular family (outlined style) -->
<i class="fa-regular fa-heart"></i>
```

#### In Rails views

Use inside a `link_to` block (not the string version — a block lets you mix HTML):

```erb
<%# ✅ Works — block form allows HTML inside %>
<%= link_to my_path, class: "btn btn-primary" do %>
  <i class="fa-solid fa-user-plus"></i> New Trainer
<% end %>

<%# ❌ Won't work — string form escapes HTML %>
<%= link_to "<i class='fa-solid fa-user-plus'></i> New Trainer", my_path %>
```

#### Built-in animations

Font Awesome 6 has CSS animations you just add as a class — no custom keyframes needed:

| Class | Effect | Used in this app |
|---|---|---|
| `fa-bounce` | Bounces on load | Footer icons |
| `fa-spin` | Spins continuously | Loading states |
| `fa-pulse` | Spins in steps | Spinner variant |
| `fa-shake` | Shakes side to side | Error feedback |
| `fa-beat` | Pulses in size | Liked/favorited states |
| `fa-flip` | Flips on an axis | Toggle buttons |

```html
<!-- Bounces on page load, loops forever -->
<i class="fa-solid fa-graduation-cap fa-bounce"></i>
```

#### Icons used in this app

| Icon | Class | Where |
|---|---|---|
| Dice | `fa-solid fa-dice` | Navbar + index "Random" button |
| User plus | `fa-solid fa-user-plus` | "New Trainer" button |
| Dove | `fa-solid fa-dove` | "Release" button on trainer profile |
| Graduation cap | `fa-solid fa-graduation-cap fa-bounce` | Footer — Le Wagon link |
| Database | `fa-solid fa-database fa-bounce` | Footer — PokéAPI link |
| Font Awesome logo | `fa-brands fa-font-awesome fa-bounce` | Footer — Font Awesome link |

> Browse all icons at [fontawesome.com/icons](https://fontawesome.com/icons) — filter by "Free" to see what's available without a Pro licence.

### Data-driven CSS Classes

A clean pattern used for type badges: instead of writing conditionals in the view, you let the data value *become* the CSS class:

```erb
<%# The element_type string ("fire", "water"...) becomes part of the class name %>
<span class="type-badge type-<%= pokemon.element_type %>"><%= pokemon.element_type %></span>
```

```scss
// Each type gets one rule — no Ruby logic needed
.type-fire     { background-color: $type-fire; }
.type-water    { background-color: $type-water; }
// etc.
```

This works because PokéAPI returns type names as lowercase strings that match the CSS class names exactly. No helper method, no JavaScript, no conditional logic in the view.

### Rainbow Card Hover Effect

The signature animation on Pokémon cards uses a CSS `::after` pseudo-element with a `hue-rotate` keyframe animation — no JavaScript needed:

```scss
.pokemon-card::after {
  content: '';
  position: absolute;
  inset: -2px;           // slightly bigger than the card
  z-index: -1;           // sits behind the card
  background: linear-gradient(135deg, #ff0000, #ff7700, #ffff00, #00ff00, #0099ff, #6600ff, #ff0099);
  filter: blur(6px) hue-rotate(0deg);
  opacity: 0;
}

.pokemon-card:hover::after {
  opacity: 0.85;
  animation: rainbow-spin 3s linear infinite;
}

@keyframes rainbow-spin {
  from { filter: blur(6px) hue-rotate(0deg); }
  to   { filter: blur(6px) hue-rotate(360deg); }
}
```

---

## 📚 Resources

- [PokéAPI](https://pokeapi.co/) — the API used for Pokémon data and sprites
- [Bootstrap 5 Docs](https://getbootstrap.com/docs/5.3/) — grid, components, utilities
- [Bootstrap SCSS Customization](https://getbootstrap.com/docs/5.3/customize/sass/) — how variable overrides work
- [Font Awesome 6](https://fontawesome.com/icons) — icon library
- [Google Fonts — Press Start 2P](https://fonts.google.com/specimen/Press+Start+2P) — pixel font
- [Rails Guides — Active Record Associations](https://guides.rubyonrails.org/association_basics.html)
- [Rails Guides — Routing](https://guides.rubyonrails.org/routing.html)
- [Stimulus Handbook](https://stimulus.hotwired.dev/handbook/introduction)
- [Cloudinary Rails SDK](https://cloudinary.com/documentation/rails_integration)
- [simple_form docs](https://github.com/heartcombo/simple_form)

---

## 🎓 Built at Le Wagon

This app was built during the **Rails Reboot** lecture as part of the Le Wagon coding bootcamp curriculum. It covers the full MVC cycle, ActiveRecord associations, file uploads, and a touch of Stimulus JS.

*Happy coding! ⚡*
