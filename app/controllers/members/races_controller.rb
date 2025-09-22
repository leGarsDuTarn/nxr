module Members
  class RacesController < BaseController
    include Paginable
    def index
      @races = Race.order(date: :asc)

      # Recherche (si param q présent)
      @races = @races.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @races = @races.with_attached_image if Race.reflect_on_attachment(:image)

      # Pagination Kaminari
      @races = apply_pagination(@races)
    end

    def show
      @race = Race.find(params[:id])
      @registration = current_user.registrations.find_by(registerable: @race)
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
