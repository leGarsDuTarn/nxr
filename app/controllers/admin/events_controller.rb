module Admin
  class EventsController < BaseController
    include Paginable
    before_action :set_admin_event, only: %i[show edit update destroy]

    def index
      @events = Event.order(date: :asc)

      # Recherche
      @events = @events.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @events = @events.with_attached_image if Event.reflect_on_attachment(:image)

      # Pagination Kaminari via concern
      @events = apply_pagination(@events)
    end

    def show
      @price = @event.price_for(current_user)
    end

    def new
      @event = Event.new
    end

    def create
      @event = Event.new(event_params)
      @event.user = current_user

      if @event.save
        redirect_to admin_event_path(@event), notice: "Événement créé avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de l'événement"
      end
    end

    def edit
      # @event défini par set_admin_event
    end

    def update
      if @event.update(event_params)
        redirect_to admin_event_path(@event), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @event.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_event
      @event = Event.find(params[:id])
    end

    def event_params
      params.require(:event).permit(
        :name, :description, :date, :hour,
        :image, :remove_image,
        :club_member_price, :non_club_member_price
      )
    end
  end
end
