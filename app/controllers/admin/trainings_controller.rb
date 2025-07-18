module Admin
  class TrainingsController < BaseController
    before_action :set_admin_training, only: [:show, :edit, :update, :destroy]

    def index
      @trainings = Training.all
    end

    def show
      # @training est déjà défini par set_admin_training
    end

    def new
      @training = Training.new
    end

    def create
      @training = Training.new
      @training.user = current_user
        if @training.save
          redirect_to 
        end
    end
  end
end
