module Public
  class TrainingsController < BaseController
    include Paginable
    def index
      @trainings = Training.all.order(created_at: :desc) # :desc -> + récent en premier

      # Recherche (si param q présent)
      @trainings = @trainings.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @trainings = @trainings.with_attached_image if Training.reflect_on_attachment(:image)

      # Pagination Kaminari
      @trainings = apply_pagination(@trainings)
    end

    def show
      @training = Training.find(params[:id])
    end
  end
end
