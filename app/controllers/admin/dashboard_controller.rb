module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc).limit(2)
    end
  end
end
