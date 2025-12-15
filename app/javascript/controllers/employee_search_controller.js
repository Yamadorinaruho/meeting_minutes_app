import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "list", "item"]

  filter() {
    const query = this.inputTarget.value.toLowerCase()

    this.itemTargets.forEach(item => {
      const name = item.dataset.name.toLowerCase()
      const department = item.dataset.department.toLowerCase()

      if (name.includes(query) || department.includes(query)) {
        item.style.display = ""
      } else {
        item.style.display = "none"
      }
    })
  }

  clear() {
    this.inputTarget.value = ""
    this.filter()
  }
}
