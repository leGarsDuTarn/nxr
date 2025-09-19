# app/models/concerns/searchable.rb
module Searchable
  extend ActiveSupport::Concern

  class_methods do
    # text: Array[String|Symbol] des colonnes texte à chercher (au moins 1)
    # date: String|Symbol optionnel, ex : :date, :published_at
    # two_digit_year_pivot: pivot pour DD/MM/YY (00..pivot-1 => 2000+, pivot..99 => 1900+)
    def searchable_by(text:, date: nil, two_digit_year_pivot: 50)
      text_cols = Array(text).map(&:to_s)

      scope :search, lambda { |q|
        q = q.to_s.strip
        return all if q.blank?

        # --- Filtre date si demandé et si la colonne existe ---
        if date && column_names.include?(date.to_s)
          # DD/MM/YYYY
          if q.match?(/\A\d{2}\/\d{2}\/\d{4}\z/)
            begin; d = Date.strptime(q, "%d/%m/%Y"); return where(date => d); rescue ArgumentError; return none; end
          # MM/YYYY
          elsif q.match?(/\A\d{2}\/\d{4}\z/)
            mm, yyyy = q.split("/").map(&:to_i)
            return none unless (1..12).cover?(mm)
            
            from = Date.new(yyyy, mm, 1)
            return where(date => from..from.end_of_month)
          # DD/MM/YY (pivot)
          elsif q.match?(/\A\d{2}\/\d{2}\/\d{2}\z/)
            begin
              d, m, yy = q.split("/").map(&:to_i)
              yyyy = (yy < two_digit_year_pivot) ? (2000 + yy) : (1900 + yy)
              return where(date => Date.new(yyyy, m, d))
            rescue ArgumentError
              return none
            end
          # ISO YYYY-MM-DD
          elsif q.match?(/\A\d{4}-\d{2}-\d{2}\z/)
            begin; d = Date.iso8601(q); return where(date => d); rescue ArgumentError; return none; end
          # ISO YYYY-MM
          elsif q.match?(/\A\d{4}-\d{2}\z/)
            y, m = q.split("-").map(&:to_i)
            return none unless (1..12).cover?(m)

            from = Date.new(y, m, 1)
            return where(date => from..from.end_of_month)
          # YYYY
          elsif q.match?(/\A\d{4}\z/)
            y = q.to_i
            return where(date => Date.new(y,1,1)..Date.new(y,12,31))
          end
        end

        # --- Recherche texte (multi-colonnes dynamiques) ---
        sanitized = "%#{sanitize_sql_like(q)}%"
        cols = text_cols.select { |c| column_names.include?(c) }
        return all if cols.empty? # aucune colonne, on évite l’erreur SQL

        sql = cols.map { |c| "#{c} ILIKE :q" }.join(" OR ")
        where(sql, q: sanitized)
      }
    end
  end
end
