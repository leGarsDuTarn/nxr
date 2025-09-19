module Public
  class GalleriesController < BaseController
    include Paginable
    def index
      @galleries = Gallery.all.order(created_at: :desc) # :desc -> + récent en premier

      # Recherche
      @galleries = @galleries.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @galleries = @galleries.with_attached_images if Gallery.reflect_on_attachment(:images)

      # Pagination Kaminari via concern
      @galleries = apply_pagination(@galleries)
    end

    def show
      @gallery = Gallery.find(params[:id])
    end
  end
end
