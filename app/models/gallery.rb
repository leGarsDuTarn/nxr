class Gallery < ApplicationRecord
  belongs_to :user

  # Offre à l'admin la possibilté d'ajouter des images pour la création d'une galerie
  has_one_attached :image
  # Validation obligatoire pour pouvoir créer une gallerie
  validates :title, presence: { message: "Vous devez renseigner un titre" }, uniqueness:
  { message: "Ce titre est déjà utilisé" }
  validates :image, presence: { message: "Vous devez ajouter une image" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
end
