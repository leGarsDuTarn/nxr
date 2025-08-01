class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    # Champs supplémentaires autorisés à être envoyé en + des champs par défaut
    authorized_keys = %i[
      user_name first_name last_name birth_date
      club_name club_member address post_code town phone_number
      license_code license_number club_affiliation_number avatar remove_avatar
    ]
    # Pour l'inscription -> création de compte
    devise_parameter_sanitizer.permit(:sign_up, keys: authorized_keys)
    # Pour l'édit du profil
    devise_parameter_sanitizer.permit(:account_update, keys: authorized_keys)
  end
end
