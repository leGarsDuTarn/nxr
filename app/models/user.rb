class User < ApplicationRecord
  

  # Callback pour nettoyer le champ license_number avant validation
  before_validation :normalize_license_number

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
  validates :user_name, presence: { message: "Vous devez renseigner un nom d'utilisateur" }, uniqueness:
  { case_sensitive: false, message: "Ce nom d'utilisateur est déjà pris" }

  validates :club_member, presence: { message: "vous devez sélectionner 'oui' ou 'non'" }

  validates :first_name, presence: { message: "Vous devez renseigner un prénom" }

  validates :last_name, presence: { message: "Vous devez renseigner un nom" }

  validates :birth_date, presence: { message: "Vous devez renseigner une date de naissance" }

  validates :email, presence: { message: "Vous devez renseigner un email" }, format:
  { with: URI::MailTo::EMAIL_REGEXP, message: "exemple : john@gmail.com" }

  validates :club_name, presence: { message: "Vous devez renseigner le nom de votre club" }

  validates :phone_number, presence: { message: "Vous devez renseigner un numéro de téléphone" }, format:
  { with: /\A0\d{9}\z/, message: "format invalide - 10 chiffres sans espace (ex: 0612345678)" }

  VALID_PASSWORD_REGEX = /\A
  (?=.{8,})             # Au moins 8 caractères
  (?=.*\d)              # Au moins un chiffre
  (?=.*[a-z])           # Au moins une minuscule
  (?=.*[A-Z])           # Au moins une majuscule
  (?=.*[[:^alnum:]])    # Au moins un caractère spécial
  /x
  validates :password, format: { with: VALID_PASSWORD_REGEX, message:
  "Doit contenir au moins 8 caractères, une majuscule, une minuscule, un chiffre et un caractère spécial" }, if: :password_required?

  # Permet à l'utilisateur de modifier son user_name ou son email
  # sans être obligé de retaper ou de changer son mot de passe.
  # La validation du mot de passe ne s'applique que lors de la création du compte
  # ou lorsque le mot de passe est explicitement modifié.
  def password_required?
    !persisted? || !password.nil? || !password_confirmation.nil?
  end

  # Permet de controler que le champ 'code licence soit bien rempli'
  # Évite que l'utilisateur ne renseigne un mauvais code licence qui n'existerais pas chez la FFM
  validates :license_code, presence: { message: "Vous devez renseigner un code de licence valide" }
  validates :license_code, inclusion: {
    in: %w[NCO NCP NGM NTR NVE MAT MAT2 NET ETR ETJ LDI OFF OML OFS NJ1 NJ2 NJ3 NJ3C NPH NEH LAP LES TIM NTO],
    message: "%{value} n'est pas un code de licence FFM valide"
  }

  # Permet de controler que le champ 'Nunméro de licence soit bien rempli'
  # Oblige l'utilisateur à remplir exactement 6 chiffres.
  validates :license_number, presence: { message: "Vous devez renseigner un numéro de licence valide" }, uniqueness:
  { case_sensitive: false, message: "Ce numéro de licence existe déjà" }
  validates :license_number, format: {
    with: /\A\d{6}\z/,
    message: "Le numéro de licence doit contenir 6 chiffres"
  }

  # Permet de pas enregister en DB deux plaques identiques pour 2 motos.
  validates :plate_number, uniqueness:
  {
    case_sensitive: false,
    message: "Ce numéro de plaque d'imatriculation existe déjà"
  }, allow_blank: true
  # Conditionne le format des plaques d'immatriculations
  validates :plate_number, format: {
    with: /\A[A-Z]{2}-\d{3}-[A-Z]{2}\z/,
    allow_blank: true, # Permet de laisser le champ libre si la moto n'est pas homologuée route
    message: "Format de plaque invalide (ex: AB-123-CD)"
  }
  # Creation d'une constante avec une liste exhaustive de plusieurs marques de motocross
  VALID_BRANDS = %w[
    KTM Yamaha Honda Suzuki Kawasaki Husqvarna GasGas Beta
    TM_Racing CRZ_ERZ BASTOS Mini_MX KAYO_Motors Gunshot Apollo GPX BHR Autre
  ]
  # Permet de créer une liste déroulante dans le form
  validates :bike_brand, inclusion: { in: VALID_BRANDS }, allow_blank: true
  # La cylindré ne peut être inferieure a 50cc
  validates :cylinder_capacity, numericality: { greater_than: 49, message: "La cylindrée doit-être supérieure à 50cc" }
  # Permet d'avoir une liste déroulante dans le forme avec 2Temps ou 4Temps
  enum stroke_type: { two_stroke: "2T", four_stroke: "4T" }
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable

  validates :race_number, uniqueness:
  {
    message: "Ce numéro de plaque d'imatriculation existe déjà"
  }, allow_blank: true
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
    registrations.where(registerable_type: "Races").map(&:registerable)
  end

  private

  def normalize_license_number
    self.license_number = license_number.strip if license_number.present?
  end
end
