class Race < ApplicationRecord
  include HasPrices # Voir models/concerns/has_prices.rb

  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy
  has_many :users, through: :registrations

  # Permet de faire une rechercher au niveau de races/index.html.erb
  scope :search, lambda { |q|
    next all if q.blank?

    where("name ILIKE :q OR description ILIKE :q", q: "%#{q.strip}%")
  }

  # Offre à l'admin la possibilté d'ajouter une image pour la création d'une course
  has_one_attached :image
  # Permet de supprimer l'image via la partiale view/race/_form.html.erb
  attr_accessor :remove_image

  # Validation obligatoire pour pouvoir créer une course
  validates :name, presence: { message: "Vous devez renseigner un nom" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
  validates :hour, presence: { message: "Vous devez renseigner une heure" }

  # Purge l'image si la checkbox est cochée
  before_save :purge_image, if: -> { remove_image == "1" }

  private

  # Permet de supprimer l'image
  def purge_image
    image.purge_later
  end
end
