class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: [ :home ]

  def home
    # Permet d'afficher uniquement les courses à venir
    @races = Race.where("date >= ?", Date.today).order(date: :asc)
  end
end
