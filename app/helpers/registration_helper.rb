module RegistrationHelper
  # Helper qui permet de centraliser la génération des liens d'incriptions en fonction des routes - évite le DRY
  # Permet de générer dynamiquement un lien d'inscription en fonction de la route (resource)
  # Intégration dans une vue -> <%= registration_link(@race) %> @race === resource
  def registration_link(resource)
    # Guard Clause -> vérifie si l'utilisateur connecté est un membre ou un admin si false ne rentre pas dans la méthode
    return unless current_user&.member? || current_user&.admin?

    # Permet de vérifier si l'utilisateur est déjà inscrit à cette ressource
    registration = current_user.registrations.find_by(registerable: resource)

    if registration.present?
      case registration.status
      when "pending"
        content_tag(:span, "Inscription enregistrée en attente de validation", class: "btn btn-warning disabled")
      when "validated"
        content_tag(:span, "Inscription enregistrée & validée", class: "btn btn-success disabled")
      when "rejected"
        content_tag(:span, "Inscription refusée", class: "btn btn-danger disabled")
      else
        content_tag(:span, "Inscription enregistrée", class: "btn btn-secondary disabled")
      end
    else
      path = case resource
             when Race
               new_members_race_registration_path(resource)
             when Training
               new_members_training_registration_path(resource)
             when Event
               new_members_event_registration_path(resource)
             end
      link_to "Je m'inscris", path, class: "btn btn-success" if path
    end
  end

  # Permet d'afficher dans les inscriptions aux activités le reglement du club
  def club_regulation_text
    Club.first.participation_terms.last&.content.to_s
  end
end
