module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc).limit(3)
      @trainings = Training.all.order(date: :asc).limit(3)
      @races = Race.all.order(date: :asc).limit(3)
      @articles = Article.all.order(date: :asc).limit(6)
      @galleries = Gallery.all.order(date: :asc).limit(6)
      @users = User.all.order(created_at: :asc).limit(6)
      @recent_registrations = Registration.includes(:user, :registerable).order(created_at: :desc).limit(6)
      @club = Club.first
      @privacy_policy = PrivacyPolicy.first
      @legal_notice = LegalNotice.first
    end
  end
end
