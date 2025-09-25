module Admin
  class PrivacyPoliciesController < BaseController
    before_action :set_privacy_policy, only: [:show, :edit, :update, :destroy]

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

    def destroy
      @privacy_policy.destroy
      redirect_to admin_root_path, notice: "Politique de confidentialité supprimée."
    end

    private

    def set_privacy_policy
      # Option 1: Si vous voulez toujours le premier (singleton pattern)
      @privacy_policy = PrivacyPolicy.first
      redirect_to new_admin_privacy_policy_path, alert: "Aucune politique de confidentialité trouvée." if @privacy_policy.nil?

      # Option 2: Si vous voulez gérer par ID (recommandé)
      # @privacy_policy = PrivacyPolicy.find(params[:id])
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
