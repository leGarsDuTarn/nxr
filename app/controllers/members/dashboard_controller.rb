module Members
  class DashboardController < BaseController
    def index
      @races = Race.all
    end
  end
end
