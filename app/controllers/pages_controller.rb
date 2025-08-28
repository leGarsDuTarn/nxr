class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [:home]

  def home
    # Permet d'afficher les événements à venir
    races = Race.where("date >= ?", Date.today)
                .order(:date)
                .limit(1)
                .select("id, name, date, 'Race' as type")

    events = Event.where("date >= ?", Date.today)
                  .order(:date)
                  .limit(1)
                  .select("id, name, date, 'Event' as type")

    trainings = Training.where("date >= ?", Date.today)
                        .order(:date)
                        .limit(1)
                        .select("id, name, date, 'Training' as type")

    @upcoming_activities = (races + events + trainings)
                           .sort_by(&:date)
                           .first(6)
  end
end
