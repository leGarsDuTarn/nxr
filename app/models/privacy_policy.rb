class PrivacyPolicy < ApplicationRecord
  before_validation :strip_title

  # Offre à l'admin la possibilité d'ajouter une image pour la création d'une politique de confidentialité
  has_one_attached :image
  # Permet de supprimer l'image via le form
  attr_accessor :remove_image

  validates :title, presence: { message: "Vous devez renseigner un titre" }, length: { minimum: 3 }
  validates :body,  presence: { message: "Vous devez renseigner ce champs" }

  private

  # Permet d'enlever les espaces blanc au début et à la fin du titre
  def strip_title
    self.title = title&.strip
  end
end
