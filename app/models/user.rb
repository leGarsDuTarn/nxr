class User < ApplicationRecord
  # Call back -> voir section private
  before_validation :normalize_license_number
  before_validation :normalize_license_code
  before_validation :normalize_user_name
  before_validation :normalize_first_name
  before_validation :normalize_last_name
  before_validation :normalize_club_name

  has_many :events, dependent: :destroy
  has_many :trainings, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :registrations, dependent: :destroy

  # Associations pour les activités auxquelles l'utilisateur est INSCRIT
  has_many :registered_events, through: :registrations, source: :registerable, source_type: 'Event'
  has_many :registered_races, through: :registrations, source: :registerable, source_type: 'Race'
  has_many :registered_trainings, through: :registrations, source: :registerable, source_type: 'Training'

  # Permet que chaque inscription soit uniquement en role members
  enum role: { member: "member", admin: "admin" }

  after_initialize :set_default_role, if: :new_record?

  def set_default_role
    self.role ||= "member"
  end

  # Offre la possibilté à l'user d'ajouter un avatar
  has_one_attached :avatar
  validate :limit_size_avatar
  # Permet de supprimer l'avatar via le questionnaire view/users/_form.html.erb
  attr_accessor :remove_avatar

  # Méthode permettant de limiter la taille des fichiers des avatars et leur types
  def limit_size_avatar
    # Si un utilisateur a ajouté un avatar
    return unless avatar.attached?

    # Alors le fichier ne doit pas dépasser la taille de 2Mo
    errors.add(:avatar, "doit être inférieur à 2 Mo") if avatar.byte_size > 2.megabytes

    # Fichier accepté JPEG ou PNG sinon erreur
    acceptable_types = ["image/jpeg", "image/png"]
    return if acceptable_types.include?(avatar.content_type)

    errors.add(:avatar, "doit être un fichier de type JPEG ou PNG")
  end

  # J'ai mis un validate afin que les users n'aient pas le même username
  # Je l'ai renforcé avec case_sensitive donc Benji et benji sont egaux
  # J'ai également mis un message pour une UX plus propre
  validates :user_name, presence: { message: "Veuillez renseigner un nom d’utilisateur." }, uniqueness:
  { case_sensitive: false, message: "Oups ! Ce nom d’utilisateur est déjà pris." }
  # Valide que :club_member est true ou false
  # Message personnalisé si aucune des deux valeurs n’est sélectionnée
  validates :address, presence: { message: "Veuillez renseigner une adresse." }
  validates :post_code, presence: { message: "Veuillez renseigner un Code Postal." }
  validates :town, presence: { message: "Veuillez renseigner une Ville." }
  validates :club_member, inclusion: { in: [true, false], message: "Veuillez sélectionner 'Oui' ou 'Non'." }

  validates :first_name, presence: { message: "Veuillez renseigner un prénom." }

  validates :last_name, presence: { message: "Veuillez renseigner un nom." }

  validates :birth_date, presence: { message: "Veuillez renseigner une date de naissance." }

  validates :email, presence: { message: "Veuillez renseigner un email." }, format:
  { with: URI::MailTo::EMAIL_REGEXP, message: "exemple : john@gmail.com" }

  validates :club_name, presence: { message: "Veuillez renseigner le nom de votre club." }

  validates :phone_number, presence: { message: "Veuillez renseigner un numéro de téléphone." }, format:
  { with: /\A0\d{9}\z/, message: "Format invalide : 10 chiffres sans espace (ex. : 0612345678)." }

  VALID_PASSWORD_REGEX = /\A
  (?=.{8,})             # Au moins 8 caractères
  (?=.*\d)              # Au moins un chiffre
  (?=.*[a-z])           # Au moins une minuscule
  (?=.*[A-Z])           # Au moins une majuscule
  (?=.*[[:^alnum:]])    # Au moins un caractère spécial
  /x
  validates :password, format: { with: VALID_PASSWORD_REGEX, message:
  "Doit contenir au moins 8 caractères, dont une majuscule, une minuscule, un chiffre et un caractère spécial." }, if: :password_required?

  # Permet à l'utilisateur de modifier son user_name ou son email
  # sans être obligé de retaper ou de changer son mot de passe.
  # La validation du mot de passe ne s'applique que lors de la création du compte
  # ou lorsque le mot de passe est explicitement modifié.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # Permet de controler que le champ 'code licence soit bien rempli'
  # Évite que l'utilisateur ne renseigne un mauvais code licence qui n'existerais pas chez la FFM
  LICENCE_CODES = %w[NCO NCP NGM NTR NVE MAT MAT2 NET ETR ETJ LDI OFF OML OFS
  NJ1 NJ2 NJ3 NJ3C NPH NEH LAP LES TIM NTO].freeze
  # .freeze -> empêche toute modification du tableau en mémoire -> sécurise le code
  validates :license_code, presence: { message: "Veuillez renseigner un code de licence valide." }
  validates :license_code, inclusion: {
    in: LICENCE_CODES,
    message: "%{value} n’est pas un code de licence FFM valide."
  }

  # Permet de controler que le champ 'Numéro de licence soit bien rempli'
  # Oblige l'utilisateur à remplir exactement 6 chiffres.
  validates :license_number, presence: { message: "Veuillez renseigner un numéro de licence valide." }, uniqueness:
  { case_sensitive: false, message: "Oups ! Ce numéro de licence est déjà attribué." }
  validates :license_number, format: {
    with: /\A\d{6}\z/,
    message: "Le numéro de licence doit contenir 6 chiffres sans espace."
  }

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Méthodes personnalisées pour pouvoir accéder aux objet -> current_user.trainings
  def trainings
    registrations.where(registerable_type: "Training").map(&:registerable)
  end

  def events
    registrations.where(registerable_type: "Event").map(&:registerable)
  end

  def races
    registrations.where(registerable_type: "Race").map(&:registerable)
  end

  private

  def normalize_license_number
    # .to_s : évite les erreurs si nil
    # .upcase : transforme toutes les lettres en majuscule
    # .strip : supprime les espaces
    self.license_number = license_number&.upcase&.strip
  end

  def normalize_license_code
    # .to_s : évite les erreurs si nil
    # .upcase : transforme toutes les lettres en majuscule
    # .strip : supprime les espaces
    self.license_code = license_code.to_s.upcase.strip
  end

  def normalize_user_name
    # .to_s : évite les erreurs si nil
    # .strip : supprime les espaces
    # .gsub(/\s+/, ' ') : remplace les espaces multiples par un seul
    self.user_name = user_name.to_s.strip.gsub(/\s+/, ' ')
  end

  def normalize_first_name
    # .to_s : évite les erreurs si nil
    # .strip : supprime les espaces
    # .capitalize: met une majuscule sur la 1ère lettre
    # .gsub(/\s+/, ' ') : remplace les espaces multiples par un seul
    self.first_name = first_name.to_s.strip.capitalize.gsub(/\s+/, ' ')
  end

  def normalize_last_name
    # .to_s : évite les erreurs si nil
    # .strip : supprime les espaces
    # .capitalize: met une majuscule sur la 1ère lettre
    # .gsub(/\s+/, ' ') : remplace les espaces multiples par un seul
    self.last_name = last_name.to_s.strip.capitalize.gsub(/\s+/, ' ')
  end

  def normalize_club_name
    # .to_s : évite les erreurs si nil
    # .upcase : transforme toutes les lettres en majuscule
    # .strip : supprime les espaces
    # .gsub(/\s+/, ' ') : remplace les espaces multiples par un seul
    self.club_name = club_name.to_s.upcase.strip.gsub(/\s+/, ' ')
  end
end
