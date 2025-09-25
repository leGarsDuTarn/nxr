module Admin
  class PrivacyPoliciesController < BaseController
    before_action :set_privacy_policy

    def show
      # @privacy_policy déjà définie par :set_legal_notice
    end

    def edit
      # @privacy_policy déjà définie par :set_legal_notice
    end

    def update
      if @privacy_policy.update(doc_params_with_publish_time)
        redirect_to admin_privacy_policy_path, notice: "Politique de confidentialité mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_privacy_policy
      @privacy_policy = PrivacyPolicy.first_or_create!(title: "Politique de confidentialité", body: "<p>À compléter…</p>")
    end

    def doc_params
      params.require(:privacy_policy).permit(:title, :body, :published_at)
    end

    def doc_params_with_publish_time
      attrs = doc_params
      attrs[:published_at] ||= @privacy_policy.published_at || Time.current
      attrs
    end
  end
end
