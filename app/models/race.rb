class Race < ApplicationRecord
  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy

  # Offre à l'admin la possibilté d'ajouter une image pour la création d'une course
  has_one_attached :image
  # Validation obligatoire pour pouvoir créer une course
  validates :name, presence: { message: "Vous devez renseigner un nom" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
  validates :hour, presence: { message: "Vous devez renseigner une heure" }
end
