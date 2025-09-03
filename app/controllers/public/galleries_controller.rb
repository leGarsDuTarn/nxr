module Public
  class GalleriesController < BaseController
    def index
      @galleries = Gallery.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @gallerie = Gallery.find(params[:id])
    end
  end
end
