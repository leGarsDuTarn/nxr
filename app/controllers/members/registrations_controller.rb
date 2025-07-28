module Members
  class RegistrationsController < BaseController
    def new
      # Si l'URL contient un paramètre event_id, alors on veut s'inscrire à un Event
      if params[:event_id]
        @event = Event.find(params[:event_id]) # Récupération de l'event correspondant à l'ID
        # Création d'une nouvelle inscription liée à l'event_id pour l'utilisateur connecté
        @registration = current_user.registrations.new(registerable: @event)
        render :new_event # Renvoie à la vue new_event.html.erb
      # Si l'URL contient un paramètre race_id, alors on veut s'inscrire à une Race
      elsif params[:race_id]
        @race = Race.find(params[:race_id]) # Récupération de la race correspondant à l'ID
        # Création d'une nouvelle inscription liée à race_id pour l'utilisateur connecté
        @registration = current_user.registrations.new(registerable: @race)
        render :new_race
      # Si l'URL contient un paramètre training_id, alors on veut s'inscrire à un training
      elsif params[:training_id]
        @training = Training.find(params[:training_id]) # Récupération du training correspondant à l'ID
        # Création d'une nouvelle inscription liée au training_id pour l'utilisateur connecté
        @registration = current_user.registrations.new(registerable: @training)
        render :new_training
      end
    end
  end
end
