import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["track"];

  connect() {
    this.track = this.trackTarget;
    this.itemWidth =
      this.track.querySelector(".carousel-item")?.offsetWidth || 300;
  }

  next() {
    this.track.scrollBy({ left: this.itemWidth + 16, behavior: "smooth" });
  }

  prev() {
    this.track.scrollBy({ left: -(this.itemWidth + 16), behavior: "smooth" });
  }
}
