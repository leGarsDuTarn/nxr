module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc).limit(2)
      @trainings = Training.all.order(date: :asc).limit(4)
      @races = Race.all.order(date: :asc).limit(5)
      @articles = Article.all.order(date: :asc).limit(3)
      @galleries = Gallery.all.order(date: :asc).limit(3)
      @users = User.all.order(created_at: :asc).limit(4)
      @recent_registrations = Registration.includes(:user, :registerable).order(created_at: :desc).limit(10)
    end
  end
end
