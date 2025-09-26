import { Controller } from "@hotwired/stimulus";

// Carrousel "home" avec gestion automatique des flèches et centrage
export default class extends Controller {
  static targets = ["track", "prevButton", "nextButton"];
  static values = {
    step: { type: String, default: "item" }, // "item" | "page"
    keyboard: { type: Boolean, default: true },
  };

  connect() {
    this.track = this.trackTarget;
    this._resize = this._resize.bind(this);
    this._keydown = this._keydown.bind(this);
    this._scroll = this._scroll.bind(this);

    this._measure();
    this._updateNavigation();

    window.addEventListener("resize", this._resize);
    if (this.keyboardValue) document.addEventListener("keydown", this._keydown);

    // Observer les changements de scroll pour mettre à jour les flèches
    this.track.addEventListener("scroll", () => {
      clearTimeout(this.scrollTimeout);
      this.scrollTimeout = setTimeout(() => this._updateNavigation(), 100);
    });
  }

  disconnect() {
    window.removeEventListener("resize", this._resize);
    if (this.keyboardValue)
      document.removeEventListener("keydown", this._keydown);
    if (this.scrollTimeout) clearTimeout(this.scrollTimeout);
  }

  next() {
    if (this._canScrollNext()) {
      this._scroll(+1);
    }
  }

  prev() {
    if (this._canScrollPrev()) {
      this._scroll(-1);
    }
  }

  // -- privé --
  _measure() {
    const items = this.track.querySelectorAll(".home-carousel__item");
    if (items.length === 0) return;

    const firstItem = items[0];
    const styles = getComputedStyle(this.track);
    const gap = parseFloat(styles.columnGap || styles.gap || 16);

    this.itemWidth = firstItem.offsetWidth + gap;
    this.pageWidth = this.track.clientWidth * 0.9;
    this.totalItems = items.length;
    this.visibleItems = Math.floor(this.track.clientWidth / this.itemWidth);
    this.totalWidth = this.totalItems * this.itemWidth - gap; // -gap car pas de gap après le dernier item
    this.trackWidth = this.track.clientWidth;

    // Centrer si pas assez de cartes pour remplir l'espace
    this._centerIfNeeded();
  }

  _centerIfNeeded() {
    if (this.totalWidth <= this.trackWidth) {
      // Les cartes tiennent dans l'espace disponible, on les centre
      this.track.style.justifyContent = "center";
      this.track.style.overflow = "visible";
    } else {
      // Mode carrousel normal
      this.track.style.justifyContent = "flex-start";
      this.track.style.overflow = "auto";
    }
  }

  _scroll(dir) {
    const amount = this.stepValue === "page" ? this.pageWidth : this.itemWidth;
    this.track.scrollBy({ left: dir * amount, behavior: "smooth" });
  }

  _canScrollPrev() {
    return this.track.scrollLeft > 0;
  }

  _canScrollNext() {
    const maxScroll = this.track.scrollWidth - this.track.clientWidth;
    return this.track.scrollLeft < maxScroll - 1; // -1 pour gérer les arrondis
  }

  _needsNavigation() {
    return this.totalWidth > this.trackWidth;
  }

  _updateNavigation() {
    const needsNav = this._needsNavigation();

    // Afficher/cacher les boutons de navigation
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.style.display = needsNav ? "block" : "none";
      this.prevButtonTarget.disabled = !this._canScrollPrev();
      this.prevButtonTarget.style.opacity = this._canScrollPrev() ? "1" : "0.5";
    }

    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.style.display = needsNav ? "block" : "none";
      this.nextButtonTarget.disabled = !this._canScrollNext();
      this.nextButtonTarget.style.opacity = this._canScrollNext() ? "1" : "0.5";
    }
  }

  _resize() {
    this._measure();
    this._updateNavigation();
  }

  _keydown(e) {
    // n'active les flèches clavier que si le carrousel est visible et que la navigation est nécessaire
    if (!this._needsNavigation()) return;

    const rect = this.track.getBoundingClientRect();
    const inView = rect.top < window.innerHeight && rect.bottom > 0;
    if (!inView) return;

    if (e.key === "ArrowRight" && this._canScrollNext()) {
      e.preventDefault();
      this.next();
    } else if (e.key === "ArrowLeft" && this._canScrollPrev()) {
      e.preventDefault();
      this.prev();
    }
  }
}
