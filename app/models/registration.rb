class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :registerable, polymorphic: true

  # Permets d'éviter les doublons d'inscription
  validates :user_id, uniqueness: { scope: %i[registerable_type registerable_id], message: "Vous êtes déjà inscrit" }
  # Permets de refuser l'inscription d'un utilisateur à un events, training ou race si ces activités sont terminées
  # Ici validate custom - empêche l'inscription si l'activité est déjà passée
  validate :activity_open
  # Permets ici de limiter l'inscription uniquement aux trois activités lister ci-dessous [Event, Race, Training]
  validates :registerable_type, inclusion: {
    in: %w[Event Race Training],
    message: "%{value} n’est pas un type d’inscription valide"
  }

  def activity_open
    return if registerable.respond_to?(:date) && registerable.date >= Date.today

    errors.add(:registerable, "cet événement n'est plus ouvert aux inscriptions")
  end
end
