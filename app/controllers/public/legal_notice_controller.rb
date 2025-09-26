module Public
  class LegalNoticeController < BaseController
    def show
      # Ici comme l'admin doit creer une politique de confidentialité
      # si l'admin n'a pas déjà crée le doc alors 'nil' et heroku casse
      # donc .first_or_initialize' évite le nil, renvoie le premier enregistrement s'il existe, ou en instancie un nouveau.
      # et Heroku ne casse plus
      @legal_notice = LegalNotice.first_or_initialize
    end
  end
end
