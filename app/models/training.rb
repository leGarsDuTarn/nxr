class Training < ApplicationRecord
  include HasPrices # Voir models/concerns/has_prices.rb
  include Searchable # Voir models/concerns/searchable.rb
  searchable_by text: %w[name description], date: :date

  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy
  has_many :users, through: :registrations

  # Offre à l'admin la possibilté d'ajouter une image pour la création d'un entrainement
  has_one_attached :image
  # Permet de supprimer l'image via la partiale view/training/_form.html.erb
  attr_accessor :remove_image

  # Validation obligatoire pour pouvoir créer un entrainement
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
