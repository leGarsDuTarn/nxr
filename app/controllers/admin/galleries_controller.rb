module Admin
  class GalleriesController < BaseController
    before_action :set_admin_gallery, only: %i[show edit update destroy]

    def index
      @galleries = Gallery.all
    end

    def show
      # @gallery déjà definie par set_admin_gallery
    end

    def new
      @gallery = Gallery.new
    end

    def create
      @gallery = Gallery.new(gallery_params)
      @gallery.user = current_user

      if @gallery.save
        redirect_to admin_gallery_path(@gallery), notice: "Galerie créée avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de la galerie"
      end
    end

    def edit
      # @gallery déjà definie par set_admin_gallery
    end

    def update
      # Permet de supprimer les images sélectionnées (voir méthode private)
      purge_selected_images if params[:gallery][:remove_images].present?
      if @gallery.update(gallery_params)
        redirect_to admin_gallery_path(@gallery), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @gallery.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_gallery
      @gallery = Gallery.find(params[:id])
    end

    def gallery_params
      params.require(:gallery).permit(:title, :date, images: [], remove_images: [])
    end

    def purge_selected_images
      params[:gallery][:remove_images].each do |image_id|
        # Recherche une image par son ID et la supprime uniquement si elle existe (grâce à l'opérateur &.)
        @gallery.images.find_by_id(image_id)&.purge
      end
    end
  end
end
