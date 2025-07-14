class Event < ApplicationRecord
  belongs_to :user
  has_many :registrations, as: :registerable, dependent: :destroy
end
