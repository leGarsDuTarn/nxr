class Members::RegistrationsController < ApplicationController
  def new_event
    @event = Event.find(params[:event_id]) # Permet de sélectionner l'event par son ID
    # Créer une nouvelle instance d'inscription liée à l'utilisateur actuel
    @registration = current_user.registrations.new(registerable: @event)
  end

  def new_race
    @race = Race.find(params[:race_id]) # Permet de sélectionner la race par son ID
    # Créer une nouvelle instance d'inscription liée à l'utilisateur actuel
    @registration = current_user.registrations.new(registerable: @race)
  end

  def new_training
    @training = Training.find(params[:training_id]) # Permet de sélectionner le training par son ID
    # Créer une nouvelle instance d'inscription liée à l'utilisateur actuel
    @registration = current_user.registration.new(registerable: @training)
  end
end
