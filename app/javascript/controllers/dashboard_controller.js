// app/javascript/controllers/carousel_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["track"];
  static values = {
    step: { type: String, default: "item" },
    keyboard: { type: Boolean, default: true },
  };

  connect() {
    this.trackEl = this.trackTarget;
    this._resize = this._resize.bind(this);
    this._keydown = this._keydown.bind(this);

    // (A) re-mesure initiale
    this._measure();
    this._toggleCentered();

    // (B) re-mesurer après chargement des images (first paint correct)
    this._waitImagesThen(() => {
      this._measure();
      this._toggleCentered();
    });

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

  // --- privé ---
  _measure() {
    const firstItem = this.trackEl.querySelector(".home-carousel__item");
    const styles = getComputedStyle(this.trackEl);
    const gap = parseFloat(styles.columnGap || styles.gap || 16);

    this.gap = isNaN(gap) ? 16 : gap;
    this.itemWidth = firstItem?.offsetWidth || 300;
    this.pageWidth = this.trackEl.clientWidth * 0.9;
  }

  _scroll(dir) {
    const amount =
      this.stepValue === "page" ? this.pageWidth : this.itemWidth + this.gap;
    this.trackEl.scrollBy({ left: dir * amount, behavior: "smooth" });
  }

  _resize() {
    this._measure();
    this._toggleCentered();
  }

  _keydown(e) {
    const rect = this.trackEl.getBoundingClientRect();
    const inView = rect.top < window.innerHeight && rect.bottom > 0;
    if (!inView) return;

    if (e.key === "ArrowRight") this.next();
    else if (e.key === "ArrowLeft") this.prev();
  }

  _toggleCentered() {
    const items = this.trackEl.querySelectorAll(".home-carousel__item");
    const itemCount = items.length;

    // largeur totale réelle des items + gaps
    const totalWidth =
      itemCount * this.itemWidth + Math.max(0, itemCount - 1) * this.gap;

    // déborde si la largeur totale dépasse la largeur visible
    const overflows = totalWidth > this.trackEl.clientWidth + 0.5;

    // Règle métier : centrer & cacher flèches si (1 à 3 items) ET pas de débord
    const fewItems = itemCount > 0 && itemCount <= 3;
    const shouldCenter = fewItems && !overflows;

    this.element.classList.toggle("is-centered", shouldCenter);

    // accessibilité: si cachées visuellement, on enlève du tab order
    const navs = this.element.querySelectorAll(".home-carousel__nav");
    navs.forEach((btn) => {
      if (shouldCenter) {
        btn.setAttribute("aria-hidden", "true");
        btn.setAttribute("tabindex", "-1");
      } else {
        btn.removeAttribute("aria-hidden");
        btn.removeAttribute("tabindex");
      }
    });
  }

  _waitImagesThen(cb) {
    const imgs = Array.from(this.trackEl.querySelectorAll("img"));
    const unloaded = imgs.filter((img) => !img.complete);
    if (unloaded.length === 0) {
      cb();
      return;
    }
    let left = unloaded.length;
    const done = () => {
      left--;
      if (left === 0) cb();
    };
    unloaded.forEach((img) => {
      img.addEventListener("load", done, { once: true });
      img.addEventListener("error", done, { once: true });
    });
  }
}
