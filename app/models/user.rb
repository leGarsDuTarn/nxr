class User < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :trainings, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :registrations, dependent: :destroy

  # Offre la possibilté à l'user d'ajouter un avatar
  has_one_attached :avatar

  # J'ai mis un validate afin que les users n'aient pas le même username
  # Je l'ai renforcé avec case_sensitive donc Benji et benji sont egaux
  # J'ai également mis un message pour une UX plus propre
  validates :user_name, presence: { message: "Vous devez renseigner un nom d'utilisateur" }, uniqueness:
  { case_sensitive: false, message: "Ce nom d'utilisateur est déjà pris" }
  validates :first_name, presence: { message: "Vous devez renseigner un prénom" }
  validates :last_name, presence: { message: "Vous devez renseigner un nom" }
  validates :email, presence: { message: "Vous devez renseigner un email" }, format:
  { with: URI::MailTo::EMAIL_REGEXP, message: "exemple : john@gmail.com" }
  validates :phone_number, presence: { message: "Vous devez renseigner un numéro de téléphone" }, format:
  { with: /\A0\d{9}\z/, message: "format invalide - 10 chiffres sans espace (ex: 0612345678)" }

  VALID_PASSWORD_REGEX = /\A
  (?=.{8,})              # Au moins 8 caractères
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

  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # Méthodes personnalisées pour pouvoir accéder aux objet -> current_user.trainings
  def trainings
    registrations.where(registerable_type: "Training").map(&:registerable)
  end

  def events
    registrations.where(registerable_type: "Events").map(&:registerable)
  end

  def races
    registrations.where(registerable_type: "Races").map(&:registerable)
  end
end
