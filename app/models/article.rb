class Article < ApplicationRecord
  belongs_to :user

  # Offre à l'admin la possibilité d'ajouter des images pour la création d'un article
  has_one_attached :image
  # Validation obligatoire pour pouvoir créer un article
  validates :title, presence: { message: "Vous devez renseigner un titre" }, uniqueness:
  { message: "Ce titre est déjà utilisé" }
  validates :content, presence: { message: "Vous devez renseigner ce champ" }
end
