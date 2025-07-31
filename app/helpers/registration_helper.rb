module RegistrationHelper
  # Helper qui permet de centraliser la génération des liens d'incriptions en fonction des routes - évite le DRY
  # Permet de générer dynamiquement un lien d'inscription en fonction de la route (resource)
  # Intégration dans une vue -> <%= registration_link(@race) %> @race === resource
  def registration_link(resource)
    # Guard Clause -> vérifie si l'utilisateur connecté est un membre ou un admin si false ne rentre pas dans la méthode
    return unless current_user&.member? || current_user&.admin?

    # Permet de vérifier si l'utilisateur est déjà inscrit à cette ressource
    already_registered = current_user.registrations.exists?(registerable: resource)

    if already_registered
      content_tag(:span, "Vous êtes déja inscrit", class: "btn btn-secondary disabled")
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
end
