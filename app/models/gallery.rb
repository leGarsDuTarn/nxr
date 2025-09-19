class Gallery < ApplicationRecord
  include Searchable # Voir models/concerns/searchable.rb
  searchable_by text: %w[title], date: :date

  belongs_to :user
  searchable_by text: %w[title], date: :date

  # Offre à l'admin la possibilté d'ajouter plusieurs images pour la création d'une galerie
  has_many_attached :images
  # Permet de supprimer plusieurs images via le questionnaire view/galleries/_form.html.erb
  attr_accessor :remove_images

  # Validation obligatoire pour pouvoir créer une gallerie
  validates :title, presence: { message: "Vous devez renseigner un titre" }, uniqueness:
  { message: "Ce titre est déjà utilisé" }
  validates :images, presence: { message: "Vous devez ajouter une ou plusieurs images" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
end
