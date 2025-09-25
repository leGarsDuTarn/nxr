module Admin
  class LegalNoticesController < BaseController
    before_action :set_legal_notice, only: [:show, :edit, :update]

    def show; end
    def edit; end

    def new
      # si déjà créé, on redirige vers edit (on veut un seul doc)
      if LegalNotice.exists?
        redirect_to edit_admin_legal_notice_path, alert: "Les mentions légales existent déjà."
      else
        @legal_notice = LegalNotice.new
      end
    end

    def create
      if LegalNotice.exists?
        redirect_to edit_admin_legal_notice_path, alert: "Les mentions légales existent déjà."
        return
      end

      attrs = doc_params
      attrs[:published_at] ||= Time.current
      @legal_notice = LegalNotice.new(attrs)

      if @legal_notice.save
        redirect_to admin_legal_notice_path, notice: "Les mentions légales ont été créées."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      attrs = doc_params
      attrs[:published_at] ||= @legal_notice.published_at || Time.current
      if @legal_notice.update(attrs)
        redirect_to admin_legal_notice_path, notice: "Mentions légales mises à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private
    
    def set_legal_notice
      @legal_notice = LegalNotice.first! # on suppose qu’elle existe dès qu’on est en show/edit/update
    end

    def doc_params
      params.require(:legal_notice).permit(:title, :body, :published_at)
    end
  end
end
