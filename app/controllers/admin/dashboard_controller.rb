module Admin
  class DashboardController < BaseController
    def index
      @events = Event.all.order(date: :asc).limit(3)
      @trainings = Training.all.order(date: :asc).limit(3)
      @races = Race.all.order(date: :asc).limit(3)
      @articles = Article.all.order(date: :asc).limit(3)
      @galleries = Gallery.all.order(date: :asc).limit(3)
      @users = User.all.order(created_at: :asc).limit(3)
      @recent_registrations = Registration.includes(:user, :registerable).order(created_at: :desc).limit(3)
      @clubs = Club.first
      @privacy_policies = PrivacyPolicy.first
      @legal_notices = LegalNotice.first
    end
  end
end
