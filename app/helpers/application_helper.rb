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
end
