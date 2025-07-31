module Members
  class TrainingsController < BaseController
    def index
      @trainings = Training.all
    end

    def show
      @training = Training.find(params[:id])
      @registration = current_user.registrations.find_by(registerable: @training)
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
