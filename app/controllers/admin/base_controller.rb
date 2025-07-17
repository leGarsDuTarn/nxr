module Admin
  # Controller custom qui permet de centraliser les régles d'accès pour toute la partie admin évite le DRY
  class BaseController < ApplicationController
    before_action :authenticate_user!
    before_action :authorize_admin!

    private

    def authorize_admin!
      redirect_to root_path, alert: "Accès non authorisé" unless current_user.admin?
    end
  end
end
