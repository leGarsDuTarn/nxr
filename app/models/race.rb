class Race < ApplicationRecord
  belongs_to :user
  has_many :registrations, as: :registrable, dependent: :destroy
end
