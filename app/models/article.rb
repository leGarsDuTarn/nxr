class Article < ApplicationRecord
  include Searchable # Voir models/concerns/searchable.rb
  searchable_by text: %w[title], date: :date

  belongs_to :user

  # Offre à l'admin la possibilité d'ajouter des images pour la création d'un article
  has_one_attached :image
  # Permet de supprimer l'image via le questionnaire view/articles/_form.html.erb
  attr_accessor :remove_image

  # Validation obligatoire pour pouvoir créer un article
  validates :title, presence: { message: "Vous devez renseigner un titre" }, uniqueness:
  { message: "Ce titre est déjà utilisé" }
  validates :content, presence: { message: "Vous devez renseigner ce champ" }
  validates :image, presence: { message: "Vous devez ajouter une image" }
end
