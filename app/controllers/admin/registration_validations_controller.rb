module Admin
  class RegistrationValidationsController < BaseController
    before_action :set_status_registration

    def validate
      # Change le statut de l'inscription en "validated" (grâce à l'enum dans le modèle qui est par default "pending")
      @registration.validated!
      # Redirige l'admin vers la page précédente (ex: la course), ou vers le dashboard si la redirection échoue
      # Affiche un message de confirmation
      redirect_back fallback_location: admin_dashboard_path, notice: "Inscription validée avec succès."
    end

    def reject
      @registration.rejected!
      redirect_back fallback_location: admin_dashboard_path, alert: "Inscription refusée"
    end

    def reset
      @registration.update(status: "pending")
      redirect_back fallback_location: admin_dashboard_path, notice: "Inscription remise en attente"
    end


    private

    def set_status_registration
      @registration = Registration.find(params[:id])
    end
  end
end
