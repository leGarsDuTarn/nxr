import { Controller } from "@hotwired/stimulus";


// Valeur requise: galleryId (l'ID de la galerie) pour la clé localStorage

export default class extends Controller {
  static values = { galleryId: Number };

  connect() {
    this.key = `gallery:${this.galleryIdValue}:remove`;
    this.selected = new Set(this._load());

    // Délégation: on écoute toutes les modifs des checkboxes "remove"
    this.onChange = (e) => {
      const t = e.target;
      if (t && t.matches('input[name="gallery[remove_images][]"]')) {
        const id = String(t.value);
        if (t.checked) this.selected.add(id);
        else this.selected.delete(id);
        this._save();
      }
    };
    this.element.addEventListener("change", this.onChange);

    // Avant submit, on matérialise la sélection en hidden inputs,
    // pour que le serveur reçoive AUSSI les images qui ne sont pas sur la page courante
    this.onSubmit = (e) => {
      // Nettoie d'anciens hidden si reloads
      this.element
        .querySelectorAll('input[type="hidden"][data-persist-checks-generated]')
        .forEach((n) => n.remove());

      for (const id of this.selected) {
        const input = document.createElement("input");
        input.type = "hidden";
        input.name = "gallery[remove_images][]";
        input.value = id;
        input.setAttribute("data-persist-checks-generated", "true");
        this.element.appendChild(input);
      }
      // Option: vider le store après submit (on laisse tel quel; on peut décommenter si tu veux)
      // localStorage.removeItem(this.key)
    };
    this.element.addEventListener("submit", this.onSubmit);

    // Ré-applique l'état coché sur la page en cours
    this._applyChecks();
  }

  disconnect() {
    this.element.removeEventListener("change", this.onChange);
    this.element.removeEventListener("submit", this.onSubmit);
  }

  _applyChecks() {
    const boxes = this.element.querySelectorAll(
      'input[name="gallery[remove_images][]"]'
    );
    boxes.forEach((cb) => (cb.checked = this.selected.has(String(cb.value))));
  }

  _load() {
    try {
      const raw = localStorage.getItem(this.key);
      return raw ? JSON.parse(raw) : [];
    } catch (_) {
      return [];
    }
  }

  _save() {
    try {
      localStorage.setItem(this.key, JSON.stringify([...this.selected]));
    } catch (_) {}
  }
}
