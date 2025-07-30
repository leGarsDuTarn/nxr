module Members
  class RegistrationsController < BaseController
    before_action :set_registration, only: %i[show edit update destroy]

    def show
      render :show_race
      # @registration
    end
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

    def create
      @registration = Registration.new(registration_params)
      # Associe l'inscription à l'utilisateur actuellement connecté
      @registration.user = current_user
      # Grâce à l'association polymorphe 'registerable', cette ligne retourne la ressource (Event, Race ou Training)
      # à laquelle l'utilisateur s'est inscrit -> ce qui permet de faire : @registerable.name
      @registerable = @registration.registerable

      if @registration.save
        # Récupère le type de la ressource (Event Race ou Training)
        type = @registerable.class.model_name.human
        # Récupère le nom de la ressource (ex : Course de Noël)
        name = @registerable.name
        # Redirige vers le tableau de bord avec un message personnalisé
        redirect_to members_dashboard_path, notice: "Inscription à #{type} « #{name} » réussie"
      else
        # Affiche dynamiquement la vue d'inscription correspondant au type de ressource (new_event, new_race, etc.)
        render "new_#{@registerable.class.name.downcase}"
      end
    end

    def edit
      render :edit_race
      # @registration -> défini dans set_registration
    end

    def update
      if @registration.update(registration_params)
        redirect_to members_dashboard_path, notice: "Inscription mise à jour avec succès"
      else
        render :edit_race, status: :unprocessable_entity
      end
    end

    def destroy
      @registration = Registration.find(params[:id])
      # Grâce à l'association polymorphe 'registerable', cette ligne retourne la ressource (Event, Race ou Training)
      # à laquelle l'utilisateur s'est inscrit -> ce qui permet de faire : @registerable.name
      @registerable = @registration.registerable
      @registration.destroy
      redirect_to members_dashboard_path, notice: "Inscription de #{@registerable.name} supprimée avec succès."
    end

    private

    def set_registration
      @registration = current_user.registrations.find(params[:id])
    end

    def registration_params
      # Attention pour une insscriptions, les données personnelles viennent de current_user (non éditables ici)
      params.require(:registration).permit(
        :registerable_id,
        :registerable_type,
        :cylinder_capacity,
        :stroke_type,
        :bike_brand,
        :race_number
      )
    end
  end
end
