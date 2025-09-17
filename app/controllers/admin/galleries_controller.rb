module Admin
  class GalleriesController < BaseController
    before_action :set_admin_gallery, only: %i[show edit update destroy]
    before_action :prepare_images_page, only: %i[edit show]  # charge @images pour la vue

    def index
      @galleries = Gallery.order(date: :desc).includes(images_attachments: :blob)
    end

    def show
      # @gallery & @images déjà définis
    end

    def new
      @gallery = Gallery.new
    end

    def create
      @gallery = Gallery.new(gallery_params.except(:remove_images))  # <= on laisse :images
      @gallery.user = current_user

      if @gallery.save
        redirect_to admin_gallery_path(@gallery), notice: "Galerie créée avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de la galerie"
      end
    end

    def edit
      # @gallery & @images déjà définis
    end

    def update
      if params[:gallery][:remove_images].present?
        @gallery.images.where(id: params[:gallery][:remove_images]).each(&:purge_later)
      end

      if @gallery.update(gallery_params.except(:images, :remove_images))  # <= on exclut :images en update
        @gallery.images.attach(gallery_params[:images]) if gallery_params[:images].present? # append
        redirect_to admin_gallery_path(@gallery), notice: "Modification réussie"
      else
        prepare_images_page
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

    # Paginer les ActiveStorage::Attachment
    def prepare_images_page
      @images = @gallery.images_attachments
                        .includes(:blob)
                        .order(created_at: :desc)
                        .page(params[:page])
                        .per(3) # ajuste si besoin
    end
  end
end
