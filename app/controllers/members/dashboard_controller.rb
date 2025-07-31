module Members
  class DashboardController < BaseController
    def index
      @registrations = current_user.registrations.includes(:registerable)
      @races = Race.all
      @trainings = Training.all
      @events = Event.all
    end
  end
end
