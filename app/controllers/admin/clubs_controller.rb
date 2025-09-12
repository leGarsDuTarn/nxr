module Admin
  class ClubsController < BaseController
    before_action :set_club, only: %i[show edit update]

    def show
      # @club est déjà défini par set_club
    end

    def edit
      # @club est déjà défini par set_club
    end

    def update
      if @club.update(club_params)
        redirect_to admin_club_path(@club), notice: "Informations du club mises à jour avec succès."
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la mise à jour du club."
      end
    end

    private

    def set_club
      # Pas besoin d'ID car il n'y a qu'un seul club
      @club = Club.first!
    end

    def club_params
      params.require(:club).permit(
        :name, :affiliation_number, :address, :post_code, :town,
        :phone_number, :email, :president_name, :responsable_communication_name
      )
    end
  end
end
