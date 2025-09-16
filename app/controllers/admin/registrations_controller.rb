# app/controllers/admin/registrations_controller.rb
module Admin
  class RegistrationsController < BaseController
    before_action :set_registerable
    before_action :set_registration, only: %i[show destroy]

    # GET /admin/(events|races|trainings)/:id/registrations(.pdf)
    def index
      @registrations = @registerable.registrations.includes(:user).order(created_at: :desc)
      # Permet de télécharger les inscriptions validées en format PDF
      respond_to do |format|
        format.html
        format.pdf do
          validated = @registrations.where(status: "validated")
          pdf = RegistrationsPdf.new(validated, @registerable)
          send_data pdf.render,
                    filename: "inscriptions_#{@registerable.name.to_s.parameterize}.pdf",
                    type: "application/pdf",
                    disposition: "inline" # "attachment" pour télécharger
        end
      end
    end

    def show
    end

    def destroy
      @registration.destroy
      redirect_to polymorphic_path([:admin, @registerable, :registrations]),
                  notice: "Inscription supprimée avec succès."
    end

    private

    def set_registerable
      @registerable =
        if params[:event_id]
          Event.find(params[:event_id])
        elsif params[:race_id]
          Race.find(params[:race_id])
        elsif params[:training_id]
          Training.find(params[:training_id])
        else
          raise ActiveRecord::RecordNotFound, "Registerable introuvable"
        end
    end

    def set_registration
      @registration = @registerable.registrations.find(params[:id])
    end
  end
end
