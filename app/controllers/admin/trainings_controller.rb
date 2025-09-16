module Admin
  class TrainingsController < BaseController
    include Paginable
    before_action :set_admin_training, only: %i[show edit update destroy]

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
      @price = @training.price_for(current_user)
    end

    def new
      @training = Training.new
    end

    def create
      @training = Training.new(training_params)
      @training.user = current_user
      if @training.save
        redirect_to admin_training_path(@training), notice: "Entraînement créé avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de l'entraînement"
      end
    end

    def edit
      # @training défini dans set_admin_training
    end

    def update
      if @training.update(training_params)
        redirect_to admin_training_path(@training), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @training.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_training
      @training = Training.find(params[:id])
    end

    def training_params
      params.require(:training).permit(
        :name, :description, :date, :hour,
        :image, :remove_image,
        :club_member_price, :non_club_member_price
      )
    end
  end
end
