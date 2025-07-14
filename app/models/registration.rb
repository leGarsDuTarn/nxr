class Registration < ApplicationRecord
  belongs_to :user
  belongs_to :registerable, polymorphic: true
end
