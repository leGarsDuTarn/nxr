module Admin
  class LegalNoticesController < BaseController
    before_action :set_legal_notice, only: %i[show edit update]

    def show
      # @legal_notice défini dans :set_legal_notice
    end

    def edit
      # @legal_notice défini dans :set_legal_notice
    end

    def new
      @legal_notice = LegalNotice.new
    end

    def create
      @legal_notice = LegalNotice.new(doc_params)

      if @legal_notice.save
        redirect_to admin_legal_notice_path, notice: "Les mentions légales ont été créées."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      purge_image_if_requested(@legal_notice)

      if @legal_notice.update(doc_params)
        redirect_to admin_legal_notice_path, notice: "Mentions légales mises à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_legal_notice
      @legal_notice = LegalNotice.first
      redirect_to new_admin_legal_notice_path, alert: "Aucune mention légale encore créée." unless @legal_notice
    end

    def doc_params
      params.require(:legal_notice).permit(:title, :body, :image, :remove_image)
      # Remplacez :body par :content si besoin
    end

    def purge_image_if_requested(record)
      return unless params.dig(:legal_notice, :remove_image) == "1"

      record.image.purge_later if record.respond_to?(:image) && record.image.attached?
    end
  end
end
