// app/javascript/controllers/home_carousel_controller.js
import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["track", "prevButton", "nextButton"];
  static values = {
    step: { type: String, default: "item" }, // "item" | "page"
    keyboard: { type: Boolean, default: true },
    proximityPx: { type: Number, default: 96 }, // zone sensible depuis chaque bord
    holdMs: { type: Number, default: 300 }, // maintien visible après dernier mouvement
  };

  connect() {
    this.track = this.trackTarget;

    // bind
    this._resize = this._resize.bind(this);
    this._keydown = this._keydown.bind(this);
    this._scrollByStep = this._scrollByStep.bind(this);
    this._onDocMouseMove = this._onDocMouseMove.bind(this);
    this._onDocMouseLeave = this._onDocMouseLeave.bind(this);
    this._keepVisible = this._keepVisible.bind(this);
    this._releaseVisible = this._releaseVisible.bind(this);

    // état
    this.showPrev = false;
    this.showNext = false;
    this.hoveringButton = false;
    this.hideTimer = null;

    // init
    this._measure();
    this._updateNavigation();

    // listeners
    window.addEventListener("resize", this._resize);
    if (this.keyboardValue) document.addEventListener("keydown", this._keydown);

    this.track.addEventListener("scroll", () => {
      clearTimeout(this.scrollTimeout);
      this.scrollTimeout = setTimeout(() => this._updateNavigation(), 80);
    });

    // Desktop uniquement : on écoute sur document pour ne pas perdre l'événement au-dessus des boutons
    if (!this._isTouch()) {
      document.addEventListener("mousemove", this._onDocMouseMove);
      document.addEventListener("mouseleave", this._onDocMouseLeave);
    }

    // Geler l'affichage pendant le survol des boutons (pour fiabiliser le clic)
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.addEventListener("mouseenter", this._keepVisible);
      this.prevButtonTarget.addEventListener(
        "mouseleave",
        this._releaseVisible
      );
    }
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.addEventListener("mouseenter", this._keepVisible);
      this.nextButtonTarget.addEventListener(
        "mouseleave",
        this._releaseVisible
      );
    }
  }

  disconnect() {
    window.removeEventListener("resize", this._resize);
    if (this.keyboardValue)
      document.removeEventListener("keydown", this._keydown);
    if (this.scrollTimeout) clearTimeout(this.scrollTimeout);
    if (this.hideTimer) clearTimeout(this.hideTimer);

    if (!this._isTouch()) {
      document.removeEventListener("mousemove", this._onDocMouseMove);
      document.removeEventListener("mouseleave", this._onDocMouseLeave);
    }

    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.removeEventListener(
        "mouseenter",
        this._keepVisible
      );
      this.prevButtonTarget.removeEventListener(
        "mouseleave",
        this._releaseVisible
      );
    }
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.removeEventListener(
        "mouseenter",
        this._keepVisible
      );
      this.nextButtonTarget.removeEventListener(
        "mouseleave",
        this._releaseVisible
      );
    }
  }

  // API
  next() {
    if (this._canScrollNext()) this._scrollByStep(+1);
  }
  prev() {
    if (this._canScrollPrev()) this._scrollByStep(-1);
  }

  // ----- Proximité souris (desktop) -----
  _onDocMouseMove(e) {
    if (this._isTouch()) return;

    const rect = this.element.getBoundingClientRect();
    // si la souris est *globalement* en face du carrousel (verticalement), on calcule la proximité horizontale
    const verticallyAligned = e.clientY >= rect.top && e.clientY <= rect.bottom;

    if (verticallyAligned) {
      const x = e.clientX - rect.left;
      const fromLeft = x;
      const fromRight = rect.width - x;

      this.showPrev = fromLeft <= this.proximityPxValue;
      this.showNext = fromRight <= this.proximityPxValue;

      this._updateNavigation();
      this._armHideTimer(); // recachera après inactivité
    } else {
      // hors zone verticale : on programme le masquage
      this._armHideTimer();
    }
  }

  _onDocMouseLeave() {
    this._armHideTimer(true); // masque immédiatement si on quitte la fenêtre
  }

  _keepVisible() {
    this.hoveringButton = true;
    if (this.hideTimer) clearTimeout(this.hideTimer);
    this._updateNavigation();
  }

  _releaseVisible() {
    this.hoveringButton = false;
    this._armHideTimer();
  }

  _armHideTimer(immediate = false) {
    if (this.hideTimer) clearTimeout(this.hideTimer);
    if (immediate) {
      this.showPrev = false;
      this.showNext = false;
      this._updateNavigation();
      return;
    }
    this.hideTimer = setTimeout(() => {
      if (!this.hoveringButton) {
        this.showPrev = false;
        this.showNext = false;
        this._updateNavigation();
      }
    }, this.holdMsValue);
  }

  // ----- Mesures & scroll -----
  _isTouch() {
    return window.matchMedia("(pointer: coarse)").matches;
  }

  _measure() {
    const items = this.track.querySelectorAll(".home-carousel__item");
    if (items.length === 0) return;

    const firstItem = items[0];
    const styles = getComputedStyle(this.track);
    const gap = parseFloat(styles.columnGap || styles.gap || 16);

    this.itemWidth = firstItem.offsetWidth + gap;
    this.pageWidth = this.track.clientWidth * 0.9;
    this.totalItems = items.length;
    this.visibleItems = Math.max(
      1,
      Math.floor(this.track.clientWidth / this.itemWidth)
    );
    this.totalWidth = this.totalItems * this.itemWidth - gap;
    this.trackWidth = this.track.clientWidth;

    this._centerIfNeeded();
  }

  _centerIfNeeded() {
    if (this.totalWidth <= this.trackWidth) {
      this.track.style.justifyContent = "center";
      this.track.style.overflow = "visible";
    } else {
      this.track.style.justifyContent = "flex-start";
      this.track.style.overflow = "auto";
    }
  }

  _scrollByStep(dir) {
    const amount = this.stepValue === "page" ? this.pageWidth : this.itemWidth;
    this.track.scrollBy({ left: dir * amount, behavior: "smooth" });
  }

  _canScrollPrev() {
    return this.track.scrollLeft > 0;
  }

  _canScrollNext() {
    const maxScroll = this.track.scrollWidth - this.track.clientWidth;
    return this.track.scrollLeft < maxScroll - 1;
  }

  _needsNavigation() {
    const EPS = 2;
    const overflow = this.track.scrollWidth - this.track.clientWidth > EPS;
    const notEnough = this.totalItems <= Math.max(2, this.visibleItems);
    return overflow && !notEnough;
  }

  _applyVisibility(el, visible) {
    if (!el) return;
    // On garde display:block pour éviter le reflow; on joue sur opacity/pointer-events/z-index
    el.style.display = "block";
    el.style.opacity = visible ? "1" : "0";
    el.style.pointerEvents = visible ? "auto" : "none";
    el.style.transform = visible
      ? "translateY(-50%)"
      : "translateY(-50%) scale(0.98)";
    el.style.zIndex = visible ? "5" : "1";
  }

  _updateNavigation() {
    const needsNav = this._needsNavigation();
    const hideAll = this._isTouch() || !needsNav;

    // gauche
    if (this.hasPrevButtonTarget) {
      const visible =
        !hideAll &&
        (this.showPrev || this.hoveringButton) &&
        this._canScrollPrev();
      this._applyVisibility(this.prevButtonTarget, visible);
    }

    // droite
    if (this.hasNextButtonTarget) {
      const visible =
        !hideAll &&
        (this.showNext || this.hoveringButton) &&
        this._canScrollNext();
      this._applyVisibility(this.nextButtonTarget, visible);
    }
  }

  _resize() {
    this._measure();
    this._updateNavigation();
  }

  _keydown(e) {
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
