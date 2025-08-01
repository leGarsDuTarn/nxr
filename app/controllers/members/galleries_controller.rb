module Members
  class GalleriesController < BaseController
    skip_before_action :authenticate_user! # Permet de rendre la page public sans création de compte

    def index
      @galleries = Gallery.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @gallerie = Gallerie.find(params[:id])
    end
  end
end
