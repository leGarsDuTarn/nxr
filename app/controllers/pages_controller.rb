class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # Permet d'afficher les événements à venir
    @races = Race.where("date >= ?", Date.today).order(date: :asc).limit(2)
    @trainings = Training.where("date >= ?", Date.today).order(date: :asc).limit(2)
    @events = Event.where("date >= ?", Date.today).order(date: :asc).limit(2)
  end
end
