module ApplicationHelper
  # Retourne l'URL de l'image à afficher en bannière pour n’importe quel "registerable" (training, race, event)
  # Si une image est attachée via ActiveStorage avec Cloudinary, utilise cette image.
  # Sinon, retourne une image par défaut
  def banner_image_url(registerable)
    if registerable.respond_to?(:image) && registerable.image.attached?
      url_for(registerable.image)
    else
      # fallback générique si aucune image n’est attachée
      asset_path("banner_mcnc.jpeg")
    end
  end

  # Retourne l'image par défaut selon le type de registerable (Race, Training, Event)
  def default_registerable_image(item)
    case item.class.name
    when "Race"
      "race_flag.png"
    when "Training"
      "training_img.png"
    when "Event"
      "logo_mcnc_3.png"
    else
      "banner_mcnc.jpeg"
    end
  end

  # Retourne l’URL d’image (attachée ou fallback)
  def registerable_image_url(item)
    if item.respond_to?(:image) && item.image.attached?
      url_for(item.image)
    else
      asset_path(default_registerable_image(item))
    end
  end

  # Permet d'avoir des liens cliquables directement depuis le form, formatage et sanitization
  def club_participation_terms_html
    text = Club.first&.participation_terms.to_s
    sanitize(
      simple_format(
        auto_link(text, html: { target: "_blank", rel: "noopener" })
      ),
      tags: %w[a p br strong em ul ol li h3 h4],
      attributes: %w[href target rel]
    )
  end

  # Permet d'avoir une model lors du click sur le lien 'Lire le règlement'
  def regulation_modal(id: "reglementModal", title: "Règlement du club")
    return "".html_safe unless Club.first&.participation_terms.present?

    <<-HTML.html_safe
      <div class="modal fade" id="#{id}" tabindex="-1" aria-labelledby="#{id}Label" aria-hidden="true">
        <div class="modal-dialog modal-lg modal-dialog-scrollable">
          <div class="modal-content rounded-4">
            <div class="modal-header">
              <h5 class="modal-title" id="#{id}Label">
                <i class="fa-regular fa-newspaper me-2"></i>#{ERB::Util.html_escape(title)}
              </h5>
              <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Fermer"></button>
            </div>
            <div class="modal-body">
              <div class="prose">
                #{club_participation_terms_html}
              </div>
            </div>
            <div class="modal-footer">
              <button type="button" class="btn-nxr" data-bs-dismiss="modal">Fermer</button>
            </div>
          </div>
        </div>
      </div>
    HTML
  end
end
