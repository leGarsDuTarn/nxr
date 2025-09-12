module HasPrices
  extend ActiveSupport::Concern

  included do
    # Validation commune
    validates :club_member_price, :non_club_member_price,
              numericality: { greater_than_or_equal_to: 0 },
              presence: { message: "Vous devez renseigner un prix" }
  end

  # Méthode commune
  # Retourne le bon prix en fonction du statut de l'utilisateur
  def price_for(user)
    return non_club_member_price if user.nil?

    user.club_member? ? club_member_price : non_club_member_price
  end
end
