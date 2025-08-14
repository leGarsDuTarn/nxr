module Public
  class RacesController < BaseController
    def index
      @races = Race.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @race = Race.find(params[:id])
    end
  end
end
