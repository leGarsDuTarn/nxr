module Public
  class TrainingsController < BaseController
    def index
      @trainings = Training.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @training = Training.find(params[:id])
    end
  end
end
