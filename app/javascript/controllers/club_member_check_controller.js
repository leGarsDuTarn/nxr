import { Controller } from "@hotwired/stimulus";

// Connects to data-controller="club-member-check"
export default class extends Controller {
  static targets = ["select", "clubNameWrapper", "affiliationWrapper"];

  connect() {
    this.toggle();
  }

  toggle() {
    if (this.selectTarget.value === "true") {
      // S'il est membre de Navès
      this.clubNameWrapperTarget.style.display = "none";
      this.affiliationWrapperTarget.style.display = "block";
    } else {
      // S'il n'est PAS membre de Navès
      this.clubNameWrapperTarget.style.display = "block";
      this.affiliationWrapperTarget.style.display = "none";
    }
  }
}
