class Training < ApplicationRecord
  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy

  # Offre la possibilté d'ajouter une image pour la création d'un entrainement
  has_one_attached :image
  # Validation obligatoire pour pouvoir créer un entrainement
  validates :name, presence: { message: "Vous devez renseigner un nom" }
  validates :date, presence: true
  validates :hour, presence: true
end
