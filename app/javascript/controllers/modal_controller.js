import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["modal", "body"]
  
  open(event) {
    // ——————————————
    // 予定がなければ何もしない
    const ids = event.currentTarget.dataset.projectIds
    if (!ids || ids.trim() === "") {
      return
    }
    // ——————————————

    fetch(`/staff/shift_requests/modal?project_ids=${ids}`)
      .then(res => res.text())
      .then(html => {
        this.bodyTarget.innerHTML = html
        this.modalTarget.classList.remove("hidden")
        this.modalTarget.classList.add("open")
      })
  }

  close() {
    this.modalTarget.classList.remove("open")
    this.modalTarget.classList.add("hidden")
    this.bodyTarget.innerHTML = ""
  }

  stop(event) {
    event.stopPropagation()
  }
}
