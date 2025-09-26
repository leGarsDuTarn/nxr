module Members
  class DashboardController < BaseController
    def index
      @registrations = current_user.registrations.includes(:registerable)
      @events = Event.all.order(date: :asc).limit(6)
      @trainings = Training.all.order(date: :asc).limit(6)
      @races = Race.all.order(date: :asc).limit(6)
    end
  end
end
