module Public
  class RacesController < BaseController
    include Paginable
    def index
      @races = Race.all.order(created_at: :desc) # :desc -> + récent en premier
      # Recherche (si param q présent)
      @races = @races.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @races = @races.with_attached_image if Race.reflect_on_attachment(:image)

      # Pagination Kaminari
      @races = apply_pagination(@races)
    end

    def show
      @race = Race.find(params[:id])
    end
  end
end
