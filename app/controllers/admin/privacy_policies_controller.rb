module Admin
  class PrivacyPoliciesController < BaseController
    before_action :set_privacy_policy, only: [:show, :edit, :update]

    def show
      # @privacy_policy défini dans :set_privacy_policy
    end

    def edit
      # @privacy_policy défini dans :set_privacy_policy
    end

    def new
      if PrivacyPolicy.exists?
        redirect_to edit_admin_privacy_policy_path, alert: "La politique de confidentialité existe déjà."
      else
        @privacy_policy = PrivacyPolicy.new
      end
    end

    def create
      if PrivacyPolicy.exists?
        redirect_to edit_admin_privacy_policy_path, alert: "La politique de confidentialité existe déjà."
        return
      end

      attrs = doc_params
      attrs[:published_at] ||= Time.current
      @privacy_policy = PrivacyPolicy.new(attrs)

      if @privacy_policy.save
        redirect_to admin_privacy_policy_path, notice: "Politique de confidentialité créée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      attrs = doc_params
      attrs[:published_at] ||= @privacy_policy.published_at || Time.current
      if @privacy_policy.update(attrs)
        redirect_to admin_privacy_policy_path, notice: "Politique de confidentialité mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_privacy_policy
      @privacy_policy = PrivacyPolicy.first!
    end

    def doc_params
      params.require(:privacy_policy).permit(:title, :body, :published_at, :image, :remove_image)
    end
  end
end
