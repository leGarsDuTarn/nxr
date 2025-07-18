module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc)
    end
  end
end
