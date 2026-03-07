// Usage in HTML:
//   data-controller="autocomplete"
//   data-autocomplete-url-value="/pokemons/autocomplete"
//
// How it works:
//   1. User types in the input → debounced fetch to the JSON endpoint
//   2. Results render as a dropdown list below the input
//   3. Clicking a result fills the input and submits the form
//   4. Clicking outside or pressing Escape closes the dropdown

import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  // Declare targets — Stimulus will find these in the DOM via data-autocomplete-target="..."
  static targets = ["input", "results"]

  // Declare values — reads from data-autocomplete-url-value attribute
  static values = { url: String }

  connect() {
    console.log("hello from stimulus controller")
    // Close dropdown if user clicks anywhere outside this controller's element
    this.closeOnOutsideClick = this.close.bind(this)
    document.addEventListener("click", this.closeOnOutsideClick)
  }

  disconnect() {
    // Always clean up event listeners when the controller disconnects
    document.removeEventListener("click", this.closeOnOutsideClick)
  }

  // Called on every keystroke (data-action="input->autocomplete#search")
  search() {
    const query = this.inputTarget.value.trim()

    // Don't search if input is empty — clear the dropdown
    if (query.length < 1) {
      this.clearResults()
      return
    }

    // Debounce: wait 200ms after the user stops typing before fetching
    clearTimeout(this.debounceTimer)
    this.debounceTimer = setTimeout(() => {
      this.fetchResults(query)
    }, 200)
  }

  async fetchResults(query) {
    try {
      const response = await fetch(`${this.urlValue}?query=${encodeURIComponent(query)}`)
      const names = await response.json()  // ["Pikachu", "Pidgey", ...]
      this.renderResults(names)
    } catch (error) {
      console.error("Autocomplete fetch failed:", error)
    }
  }

  renderResults(names) {
    if (names.length === 0) {
      this.clearResults()
      return
    }

    // Build list items for each result
    this.resultsTarget.innerHTML = names
      .map(name => `
        <li class="autocomplete-item" data-action="click->autocomplete#select" data-name="${name}">
          ${name}
        </li>
      `)
      .join("")

    this.resultsTarget.classList.remove("d-none")
  }

  // Called when user clicks a result item
  select(event) {
    const name = event.currentTarget.dataset.name
    this.inputTarget.value = name  // fill the input
    this.clearResults()
    this.inputTarget.closest("form").submit()  // submit the search form
  }

  // Close dropdown on Escape key (data-action="keydown.esc->autocomplete#close")
  close() {
    this.clearResults()
  }

  clearResults() {
    this.resultsTarget.innerHTML = ""
    this.resultsTarget.classList.add("d-none")
  }
}