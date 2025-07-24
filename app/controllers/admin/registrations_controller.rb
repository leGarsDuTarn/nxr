module Admin
  class RegistrationsController < BaseController
    before_action :set_registerable
    before_action :set_registration, only: %i[show destroy]

    # GET /admin/events/:event_id/registrations
    # GET /admin/races/:race_id/registrations
    # GET /admin/trainings/:training_id/registrations
    def index
      # Permet de récupérer toutes les inscriptions liées à l'object parent ex: event.registrations
      @registrations = @registerable.registrations.includes(:user)
    end

    # GET /admin/events/:event_id/registrations/:id
    # GET /admin/races/:race_id/registrations/:id
    # GET /admin/trainings/:training_id/registrations/:id
    def show
      # @registration - déjà défini par set_registration
    end

    def destroy
      @registration.destroy
      # Permet de rediriger vers la page d’index de l’objet parent, ex : /admin/events/3/registrations
      redirect_to polymorphic_path([:admin, @registerable, :registrations]), notice: "Inscription supprimée avec succès."
    end

    private

    # Permet de déterminer quel est l'objet parent
    def set_registerable
      @registerable =
        if params[:event_id]
          Event.find(params[:event_id])
        elsif params[:race_id]
          Race.find(params[:race_id])
        elsif params[:training_id]
          Training.find(params[:training_id])
        end
    end

    # Permet de trouver l'inscription précise à supprimer ou à afficher
    def set_registration
      @registration = @registerable.registrations.find(params[:id])
    end
  end
end
