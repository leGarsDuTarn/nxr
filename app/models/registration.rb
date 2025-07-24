class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :registerable, polymorphic: true

  # Permets d'éviter les doublons d'inscription
  validates :user_id, uniqueness: { scope: %i[registerable_type registerable_id], message: "Vous êtes déjà inscrit" }
  # Permets de refuser l'inscription d'un utilisateur à un events, training ou race si ces activités sont terminées
  # Ici validate custom
  validate :activity_open

  def activity_open
    return if registerable.respond_to(:date) && registerable.date < Date.today

    errors.add(:registerable, "cet événement n'est plus ouvert aux inscriptions")
  end
end
