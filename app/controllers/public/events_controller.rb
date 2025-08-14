module Public
  class EventsController < BaseController
    def index
      @events = Event.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @event = Event.find(params[:id])
    end
  end
end
