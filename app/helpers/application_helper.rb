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
end
