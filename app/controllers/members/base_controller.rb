module Members
  # Controller custom qui permet de centraliser les régles d'accès pour toute la partie admin évite le DRY
  class BaseController < ApplicationController
    before_action :authenticate_user!
  end
end
