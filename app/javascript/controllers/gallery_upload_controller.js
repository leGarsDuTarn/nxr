import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="gallery-upload"
export default class extends Controller {
  // Définit les éléments HTML ciblés à l'intérieur du controller, ici "container"
  static targets = ["container"]
  connect() {
  }
  addInput() {
    // Crée dynamiquement un nouveau champ <input type="file">
    const input = document.createElement("input");
    input.type = "file";
    input.name = "gallery[images][]";
    // Limite la sélection aux fichiers image uniquement
    input.accept = "image/*";
    // Ajoute ce champ dans l’élément HTML qui a le data-gallery-upload-target="container"
    this.containerTarget.appendChild(input);
  }
}
