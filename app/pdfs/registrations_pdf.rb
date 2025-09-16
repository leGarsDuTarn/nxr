# app/pdfs/registrations_pdf.rb
require "prawn"
require "prawn/table"

class RegistrationsPdf
  def initialize(registrations, registerable)
    @registrations = registrations
    @registerable  = registerable
  end

  def render
    Prawn::Document.new(page_size: "A4", margin: 36) do |pdf|
      header(pdf)
      table_of_registrations(pdf)
      footer(pdf)
    end.render
  end

  private

  # En-tête : titre + nom du registerable
  def header(pdf)
    pdf.text "Inscriptions validées", size: 18, style: :bold
    pdf.move_down 4
    pdf.text @registerable.name.to_s, size: 12
    pdf.stroke_horizontal_rule
    pdf.move_down 12
  end

  # Tableau principal
  def table_of_registrations(pdf)
    # Ligne d'en-têtes
    data = [["Prénom", "Nom", "Marque", "Cylindrée", "Type", "N° Course"]]

    # Lignes de données
    @registrations.each do |r|
      # On privilégie les champs saisis sur l'inscription, fallback sur l'utilisateur
      first = (r.user.first_name.presence || r.user&.first_name).to_s
      last  = (r.user.last_name.presence  || r.user&.last_name).to_s

      data << [
        first,                                  # Prénom
        last,                                   # Nom
        r.bike_brand.to_s,                      # Marque
        (r.cylinder_capacity.present? ? "#{r.cylinder_capacity} cc" : ""), # Cylindrée
        r.stroke_type.to_s,                     # Type
        r.race_number.to_s                      # N° Course
      ]
    end

    # --- Largeurs de colonnes dynamiques ---
    # On répartit la largeur disponible (pdf.bounds.width) par pourcentage
    bw = pdf.bounds.width
    column_widths = {
      0 => (bw * 0.23), # Prénom
      1 => (bw * 0.23), # Nom
      2 => (bw * 0.18), # Marque
      3 => (bw * 0.14), # Cylindrée
      4 => (bw * 0.12), # Type
      5 => (bw * 0.10)  # N° Course
    }

    # NB : Le "wrap" (retour à la ligne) est le comportement par défaut de Prawn
    # dans les cellules de table, tant que la cellule a une largeur définie.
    # Les mots *sans espaces* ne seront pas hyphénés automatiquement.
    # Si tu as des très longues chaînes sans espace, envisage d'insérer
    # un soft hyphen (¬) ou un zero-width space (\u200B) côté données.

    pdf.table(
      data,
      header: true,
      row_colors: %w[F7F7F7 FFFFFF],
      # inline_format permet, si besoin, d'utiliser <b>, <i>, etc. dans les cellules
      cell_style: { size: 10, padding: [6, 6, 6, 6], inline_format: true },
      column_widths: column_widths
    ) do
      # Style de l'en-tête
      row(0).font_style = :bold
      row(0).background_color = "EEEEEE"

      # Centre les colonnes 3..5 (Cylindrée, Type, N° Course)
      columns(3..5).align = :center

      # Optionnel : aligner la Marque à gauche (cohérent avec wrap)
      columns(0..2).align = :left
    end
  end

  # Pied de page : date de génération
  def footer(pdf)
    pdf.move_down 12
    pdf.text "Généré le #{I18n.l(Time.current, format: :long)}", size: 8, align: :right
  end
end
