module Members
  class DashboardController < BaseController
    def index
      @registrations = current_user.registrations.includes(:registerable)
      @events = Event.all.order(date: :asc).limit(10)
      @trainings = Training.all.order(date: :asc).limit(10)
      @races = Race.all.order(date: :asc).limit(10)
    end
  end
end
