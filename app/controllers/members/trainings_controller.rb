module Members
  class TrainingsController < BaseController
    include Paginable
    def index
      @trainings = Training.order(date: :asc)

      # Recherche
      @trainings = @trainings.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @trainings = @trainings.with_attached_image if Training.reflect_on_attachment(:image)

      # Pagination Kaminari via concern
      @trainings = apply_pagination(@trainings)
    end

    def show
      @training = Training.find(params[:id])
      @registration = current_user.registrations.find_by(registerable: @training)
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
