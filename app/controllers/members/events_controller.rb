module Members
  class EventsController < BaseController
    include Paginable
    def index
      @events = Event.order(date: :asc)

      # Recherche
      @events = @events.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @events = @events.with_attached_image if Event.reflect_on_attachment(:image)

      # Pagination Kaminari via concern
      @events = apply_pagination(@events)
    end

    def show
      @event = Event.find(params[:id])
      @registration = current_user.registrations.find_by(registerable: @event)
    end

    def destroy
      @registration = current_user.registrations.find(params[:id])
      if @registration.destroy
        redirect_to members_dashboard_path, notice: "Votre inscription a été supprimée avec succès."
      else
        redirect_to members_dashboard_path, alert: "Votre désinscription a échoué"
      end
    end
  end
end
