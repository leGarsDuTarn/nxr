import { Controller } from "@hotwired/stimulus";

// data-controller="gallery-upload"
// data-gallery-upload-target="container"
// data-gallery-upload-max-value="10"   (optionnel : limite)

// Pour charger plusieurs photos dans le form de gallerie et eviter le rechergement de page.
export default class extends Controller {
  static targets = ["container"];
  static values = { max: Number };

  addInput() {
    // Limite éventuelle
    const count =
      this.containerTarget.querySelectorAll('input[type="file"]').length;
    if (this.hasMaxValue && count >= this.maxValue) return;

    // Wrapper de la ligne
    const wrapper = document.createElement("div");
    wrapper.className = "form-group d-flex align-items-center gap-2 mb-2";

    // Input file
    const input = document.createElement("input");
    input.type = "file";
    input.name = "gallery[images][]";
    input.accept = "image/*";
    input.className = "form-control";

    // Bouton supprimer la ligne ajoutée
    const remove = document.createElement("button");
    remove.type = "button";
    remove.className = "btn btn-outline-danger btn-sm";
    remove.innerHTML = '<i class="fas fa-times"></i>';
    remove.addEventListener("click", () => wrapper.remove());

    wrapper.appendChild(input);
    wrapper.appendChild(remove);
    this.containerTarget.appendChild(wrapper);

    input.focus();
  }
}
