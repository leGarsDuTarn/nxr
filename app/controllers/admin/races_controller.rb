module Admin
  class RacesController < BaseController
    before_action :set_admin_race, only: %i[show edit update destroy]

    def index
      @races = Race.all
    end

    def show
      # @race - déjà défini par set_admin_race
    end

    def new
      @race = Race.new
    end

    def create
      @race = Race.new(race_params)
      @race.user = current_user
      if @race.save
        redirect_to admin_race_path(@race), notice: "Course crée avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de la course"
      end
    end

    def edit
      # @race - déjà défini par set_admin_race
    end

    def update
      if @race.update(race_params)
        redirect_to admin_race_path(@race), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @race.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_race
      @race = Race.find(params[:id])
    end

    def race_params
      params.require(:race).permit(:name, :description, :date, :hour, :image)
    end
  end
end
