# app/controllers/public/base_controller.rb
module Public
  class BaseController < ApplicationController
    skip_before_action :authenticate_user! # Permet de rendre la page public sans création de compte
  end
end
