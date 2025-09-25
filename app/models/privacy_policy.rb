class PrivacyPolicy < ApplicationRecord
  before_validation :strip_title

  validates :title, presence: { message: "Vous devez renseigner un titre" }, length: { minimum: 3 }
  validates :body,  presence: { message: "Vous devez renseigner ce champs" }

  private

  # Permet d'enlever les espaces blanc au début et à la fin du titre
  def strip_title
    self.title = title&.strip
  end
end
