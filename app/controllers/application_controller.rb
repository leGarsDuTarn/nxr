class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Autorise les champs personnalisés à être acceptés par Devise à l'inscription (Créer un comte)
    devise_parameter_sanitizer.permit(:sign_up, keys: [
      :user_name, :first_name, :last_name, :birth_date,
      :club_name, :club_member, :address, :post_code, :town, :country, :phone_number,
      :license_code, :license_number, :cylinder_capacity,
      :bike_brand, :stroke_type, :plate_number, :race_number, :avatar
    ])
  end
end
