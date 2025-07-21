module Admin
  class TrainingsController < BaseController
    before_action :set_admin_training, only: [:show, :edit, :update, :destroy]

    def index
      @trainings = Training.all
    end

    def show
      # @training - déjà défini par set_admin_training
    end

    def new
      @training = Training.new
    end

    def create
      @training = Training.new(training_params)
      @training.user = current_user
      if @training.save
        redirect_to admin_training_path(@training), notice: "Entraînement crée avec succès"
      else
        render :new, status: :unprocessable_entity, alerte: "Erreur lors de la création de l'entraînement"
      end
    end

    def edit
      # @training - déjà défini par set_admin_training
    end

    def update
      if @training.update(training_params)
        redirect_to admin_training_path(@training), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alerte: "Erreur lors de la modification"
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
      params.require(:training).permit(:name, :description, :date, :hour, :image)
    end
  end
end
