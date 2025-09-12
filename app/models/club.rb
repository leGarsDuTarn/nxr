class Club < ApplicationRecord
  has_one_attached :logo

  # Permet de supprimer l'image via la partiale view/event/_form.html.erb
  attr_accessor :remove_logo

  validates :name, presence: { message: "Vous devez renseigner un nom" }
  validates :address, presence: { message: "Vous devez renseigner une addresse" }
  validates :post_code, presence: { message: "Vous devez renseigner un code postal" }
  validates :town, presence: { message: "Vous devez renseigner une ville" }
  validates :phone_number, presence: { message: "Vous devez renseigner un numéro de téléphone" }
  validates :email, presence: { message: "Vous devez renseigner un email" }
  validates :affiliation_number, presence: { message: "Vous devez renseigner un numéro d'affiliation" }
  validates :logo, presence: { message: "Vous devez ajouter un logo" }

  # Purge l'image si la checkbox est cochée
  before_save :purge_logo, if: -> { remove_logo == "1" }
  before_validation :normalize_phone_number

  private

  # Permet de supprimer l'image
  def purge_logo
    logo.purge_later
  end

  def normalize_phone_number
    return if phone_number.blank?

    # Supprime tout sauf les chiffres
    normalized = phone_number.gsub(/\D/, "")

    # Si le numéro commence par "33" (format international), on le remet en 0
    normalized = "0#{normalized[2..]}" if normalized.start_with?("33")

    # Formate par paires de chiffres : "0612345678" -> "06 12 34 56 78"
    normalized = normalized.chars.each_slice(2).map(&:join).join(" ")

    self.phone_number = normalized
  end
end
