class ContactMessage
  include ActiveModel::Model

  attr_accessor :name, :email, :body

  validates :name, :email, :body, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

end
