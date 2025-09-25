module Admin
  class LegalNoticesController < BaseController
    before_action :set_legal_notice

    def show
      # @legal_notice déjà définie par :set_legal_notice
    end

    def edit
      # @legal_notice déjà définie par :set_legal_notice
    end

    def update
      if @legal_notice.update(doc_params_with_publish_time)
        redirect_to admin_legal_notice_path, notice: "Mentions légales mises à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_legal_notice
      @legal_notice = LegalNotice.first_or_create!(title: "Mentions légales", body: "<p>À compléter…</p>")
    end

    def doc_params
      params.require(:legal_notice).permit(:title, :body, :published_at)
    end

    def doc_params_with_publish_time
      attrs = doc_params
      attrs[:published_at] ||= @legal_notice.published_at || Time.current
      attrs
    end
  end
end
