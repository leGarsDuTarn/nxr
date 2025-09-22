module Public
  class EventsController < BaseController
    include Paginable
    def index
      @events = Event.all.order(created_at: :desc) # :desc -> + récent en premier

      # Recherche (si param q présent)
      @events = @events.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @events = @events.with_attached_image if Event.reflect_on_attachment(:image)

      # Pagination Kaminari
      @events = apply_pagination(@events)
    end

    def show
      @event = Event.find(params[:id])
    end
  end
end
