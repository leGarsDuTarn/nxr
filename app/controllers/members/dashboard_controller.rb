module Members
  class DashboardController < BaseController
    def index
      @registrations = current_user.registrations.includes(:registerable)
      @races = Race.all
    end
  end
end
