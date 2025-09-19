class Gallery < ApplicationRecord
  belongs_to :user

  # Permet de faire une rechercher au niveau de galleries/index.html.erb
  scope :search, lambda { |q|
    q = q.to_s.strip

    if q.blank?
      all
    elsif q.match?(/\A\d{4}-\d{2}-\d{2}\z/) # YYYY-MM-DD
      begin
        d = Date.iso8601(q)
        where(date: d)
      rescue ArgumentError
        none
      end
    elsif q.match?(/\A\d{4}-\d{2}\z/)       # YYYY-MM
      y, m = q.split("-").map(&:to_i)
      if (1..12).cover?(m)
        from = Date.new(y, m, 1)
        where(date: from..from.end_of_month)
      else
        none
      end
    elsif q.match?(/\A\d{4}\z/)             # YYYY
      y = q.to_i
      where(date: Date.new(y, 1, 1)..Date.new(y, 12, 31))
    else
      where("title ILIKE :q", q: "%#{sanitize_sql_like(q)}%")
    end
  }

  # Offre à l'admin la possibilté d'ajouter plusieurs images pour la création d'une galerie
  has_many_attached :images
  # Permet de supprimer plusieurs images via le questionnaire view/galleries/_form.html.erb
  attr_accessor :remove_images

  # Validation obligatoire pour pouvoir créer une gallerie
  validates :title, presence: { message: "Vous devez renseigner un titre" }, uniqueness:
  { message: "Ce titre est déjà utilisé" }
  validates :images, presence: { message: "Vous devez ajouter une ou plusieurs images" }
  validates :date, presence: { message: "Vous devez renseigner une date" }
end
