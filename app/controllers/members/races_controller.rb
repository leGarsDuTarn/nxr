module Members
  class RacesController < BaseController
    def index
      @races = Race.all
    end

    def show
      @race = Race.find(params[:id])
      @registration = current_user.registrations.find_by(registerable: @race)
    end

    def destroy
      @registration = current_user.registrations.find(params[:id])
      if @registration.destroy
        redirect_to members_dashboard_path, notice: "Votre inscription a été supprimée avec succès."
      else
        redirect_to members_dashboard_path, alert: "Votre désinscription a échoué"
      end
    end
  end
end
