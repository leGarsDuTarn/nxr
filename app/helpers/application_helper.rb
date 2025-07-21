module ApplicationHelper
  # Retourne l'URL de l'image à afficher en bannière pour un événement.
  # Si une image est attachée via ActiveStorage avec Cloudinary, utilise cette image.
  # Sinon, retourne une image par défaut hébergée sur Pixabay.
  def banner_image_url(event)
    if event.image.attached?
      url_for(event.image)
    else
      "https://cdn.pixabay.com/photo/2017/11/24/10/43/ticket-2974645_1280.jpg"
    end
  end

  # Retourne l'URL de l'image à afficher en bannière pour un entraînement.
  # Si une image est attachée via ActiveStorage avec Cloudinary, utilise cette image.
  # Sinon, retourne une image par défaut hébergée sur Pixabay.
  def banner_image_training_url(training)
    if training.image.attached?
      url_for(training.image)
    else
      "https://cdn.pixabay.com/photo/2017/11/24/10/43/ticket-2974645_1280.jpg"
    end
  end
end
