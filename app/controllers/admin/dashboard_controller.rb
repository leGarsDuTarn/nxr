module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc).limit(2)
      @trainings = Training.all.order(date: :asc).limit(4)
    end
  end
end
