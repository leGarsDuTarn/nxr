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

  # Creation d'une constante avec une liste exhaustive de plusieurs marques de motocross
  VALID_BRANDS = %w[
    KTM Yamaha Honda Suzuki Kawasaki Husqvarna GasGas Beta
    TM_Racing CRZ_ERZ BASTOS Mini_MX KAYO_Motors Gunshot Apollo GPX BHR Autre
  ].freeze # .freeze -> empêche toute modification du tableau en mémoire -> sécurise le code
  # Permet de créer une liste déroulante dans le form
  validates :bike_brand, inclusion: { in: VALID_BRANDS }

  # Idem mais pour des types de cynlindrées
  BIKE_CYLINDER_CAPACITY = [50, 65, 85, 125, 150, 250, 300, 350, 450, 500].freeze
  validates :cylinder_capacity, inclusion: {
    in: BIKE_CYLINDER_CAPACITY,
    message: "Veuillez indiquer une cylindrée"
  }

  # Permet d'avoir une liste déroulante dans le forme avec 2Temps ou 4Temps
  enum stroke_type: { two_stroke: "2T", four_stroke: "4T" }

  # Permet l'unicité du numéro de course
  # => Doit être unique par événement (Race, Event ou Training)
  # => Cette règle est doublée par un index unique en base de données
  # (voir migration AddUniqueIndexToRaceNumberInRegistrations)
  validates :race_number, presence: { message: "Veuillez renseigner un numéro de course" }, uniqueness: {
    scope: %i[registerable_id registerable_type],
    message: "Oups ! Ce numéro de course est déjà attribué."
  }

  private

  def activity_open
    return if registerable.respond_to?(:date) && registerable.date >= Date.today

    errors.add(:registerable, "cet événement n'est plus ouvert aux inscriptions")
  end
end
