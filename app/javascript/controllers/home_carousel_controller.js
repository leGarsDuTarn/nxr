import { Controller } from "@hotwired/stimulus";

// Carrousel "home" (indépendant du carrousel galerie)
export default class extends Controller {
  static targets = ["track"];
  static values = {
    step: { type: String, default: "item" }, // "item" | "page"
    keyboard: { type: Boolean, default: true },
  };

  connect() {
    this.track = this.trackTarget;
    this._resize = this._resize.bind(this);
    this._keydown = this._keydown.bind(this);

    this._measure();
    window.addEventListener("resize", this._resize);
    if (this.keyboardValue) document.addEventListener("keydown", this._keydown);
  }

  disconnect() {
    window.removeEventListener("resize", this._resize);
    if (this.keyboardValue)
      document.removeEventListener("keydown", this._keydown);
  }

  next() {
    this._scroll(+1);
  }
  prev() {
    this._scroll(-1);
  }

  // -- privé --
  _measure() {
    const firstItem = this.track.querySelector(".home-carousel__item");
    const styles = getComputedStyle(this.track);
    const gap = parseFloat(styles.columnGap || styles.gap || 16);
    this.itemWidth = (firstItem?.offsetWidth || 300) + gap;
    this.pageWidth = this.track.clientWidth * 0.9;
  }

  _scroll(dir) {
    const amount = this.stepValue === "page" ? this.pageWidth : this.itemWidth;
    this.track.scrollBy({ left: dir * amount, behavior: "smooth" });
  }

  _resize() {
    this._measure();
  }

  _keydown(e) {
    // n'active les flèches clavier que si le carrousel est visible
    const rect = this.track.getBoundingClientRect();
    const inView = rect.top < window.innerHeight && rect.bottom > 0;
    if (!inView) return;

    if (e.key === "ArrowRight") this.next();
    else if (e.key === "ArrowLeft") this.prev();
  }
}
