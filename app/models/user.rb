class User < ApplicationRecord
  has_many :events, dependent: :destroy
  has_many :trainings, dependent: :destroy
  has_many :races, dependent: :destroy
  has_many :articles, dependent: :destroy
  has_many :galleries, dependent: :destroy
  has_many :registrations, dependent: :destroy
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
