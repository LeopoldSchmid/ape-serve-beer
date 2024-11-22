import { Controller } from "@hotwired/stimulus"

// Renamed from reply_form_controller to submit_form_controller
export default class extends Controller {
  static targets = ["submitButton"]

  connect() {
    this.element.addEventListener('keydown', this.handleKeyPress.bind(this))
  }

  disconnect() {
    this.element.removeEventListener('keydown', this.handleKeyPress.bind(this))
  }

  handleKeyPress(event) {
    // Check for Ctrl+Enter (Windows) or Command+Enter (Mac)
    if ((event.ctrlKey || event.metaKey) && event.key === 'Enter') {
      event.preventDefault()
      this.element.requestSubmit()
    }
  }
}
