module Admin
  class PrivacyPoliciesController < BaseController
    before_action :set_privacy_policy, only: %i[show edit update]

    def show
      # @privacy_policy défini dans :set_privacy_policy
    end

    def edit
      # @privacy_policy défini dans :set_privacy_policy
    end

    def new
      @privacy_policy = PrivacyPolicy.new
    end

    def create
      @privacy_policy = PrivacyPolicy.new(doc_params)

      if @privacy_policy.save
        redirect_to admin_privacy_policy_path, notice: "Politique de confidentialité créée."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def update
      purge_image_if_requested(@privacy_policy)

      if @privacy_policy.update(doc_params)
        redirect_to admin_privacy_policy_path, notice: "Politique de confidentialité mise à jour."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def set_privacy_policy
      @privacy_policy = PrivacyPolicy.first
      redirect_to new_admin_privacy_policy_path, alert: "Aucune politique de confidentialité trouvée." unless @privacy_policy

    end

    def doc_params
      params.require(:privacy_policy).permit(:title, :body, :image, :remove_image)
    end

    def purge_image_if_requested(record)
      return unless params.dig(:privacy_policy, :remove_image) == "1"

      record.image.purge_later if record.respond_to?(:image) && record.image.attached?
    end
  end
end
