class Training < ApplicationRecord
  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy
  has_many :users, through: :registrations

  # Offre à l'admin la possibilté d'ajouter une image pour la création d'un entrainement
  has_one_attached :image
  # Validation obligatoire pour pouvoir créer un entrainement
  validates :name, presence: { message: "Vous devez renseigner un nom" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
  validates :hour, presence: { message: "Vous devez renseigner une heure" }
end
