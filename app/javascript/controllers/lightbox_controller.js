import { Controller } from "@hotwired/stimulus";

// Requiert Bootstrap (Modal) chargé globalement
export default class extends Controller {
  static targets = ["image", "title", "counter"];

  connect() {
    const el = document.getElementById("lightboxModal");
    this.modal = el ? new bootstrap.Modal(el) : null;

    // Délégation de clic : toute ancre avec data-lightbox-src
    this._onClick = (e) => {
      const link = e.target.closest("a[data-lightbox-src]");
      if (!link) return;
      e.preventDefault();

      // Capture la liste courante (ordre du DOM) à chaque ouverture
      this.items = Array.from(
        document.querySelectorAll("a[data-lightbox-src]")
      );
      this.index = Math.max(0, this.items.indexOf(link));

      this._showCurrent();
      this._bindKeys();
      this.modal?.show();
    };

    // Quand le modal se ferme, on nettoie
    this._onHidden = () => {
      this._unbindKeys();
      if (this.imageTarget) this.imageTarget.src = "";
    };

    document.addEventListener("click", this._onClick);
    el?.addEventListener("hidden.bs.modal", this._onHidden);
  }

  disconnect() {
    document.removeEventListener("click", this._onClick);
    const el = document.getElementById("lightboxModal");
    el?.removeEventListener("hidden.bs.modal", this._onHidden);
    this._unbindKeys();
  }

  // Actions
  next() {
    if (!this.items?.length) return;
    this.index = (this.index + 1) % this.items.length;
    this._showCurrent();
  }

  prev() {
    if (!this.items?.length) return;
    this.index = (this.index - 1 + this.items.length) % this.items.length;
    this._showCurrent();
  }

  // Privées
  _showCurrent() {
    const node = this.items[this.index];
    const src = node?.dataset.lightboxSrc || "";
    const alt = node?.dataset.lightboxAlt || "";

    if (this.imageTarget) {
      this.imageTarget.src = src;
      this.imageTarget.alt = alt;
    }
    if (this.titleTarget) {
      this.titleTarget.textContent = alt;
    }
    if (this.counterTarget) {
      this.counterTarget.textContent = `${this.index + 1} / ${
        this.items.length
      }`;
    }
  }

  _bindKeys() {
    this._keydown = (e) => {
      if (e.key === "ArrowRight") this.next();
      else if (e.key === "ArrowLeft") this.prev();
      else if (e.key === "Escape") this.modal?.hide();
    };
    document.addEventListener("keydown", this._keydown);
  }

  _unbindKeys() {
    if (this._keydown) {
      document.removeEventListener("keydown", this._keydown);
      this._keydown = null;
    }
  }
}
