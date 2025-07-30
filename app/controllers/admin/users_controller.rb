module Admin
  class UsersController < BaseController
    before_action :set_admin_user, only: %i[show edit update destroy]
    before_action :ensure_admin, only: [:export]

    def export
      user = User.find(params[:id])
      respond_to do |format|
        format.json do
          render json: {
            id: user.id, user_name: user.user_name, first_name: user.first_name, last_name: user.last_name,
            email: user.email, phone_number: user.phone_number, address: user.address, post_code: user.post_code,
            town: user.town, country: user.country, created_at: user.created_at, updated_at: user.updated_at
          }, status: :ok
        end
      end
    end

    def index
      @users = User.all
    end

    def show
      # @user - déjà défini dans set_admin_user
      respond_to do |format|
        format.html # => rend la vue show.html.erb
        format.json do
          render json: @user.as_json(
            only: %i[id first_name last_name email phone_number user_name address post_code town country created_at]
          )
        end
      end
    end

    def edit
      # @user - déjà défini dans set_admin_user
    end

    def update
      # Supprime l'avatar existant si l'utilisateur coche la case 'Supprimer l'avatar'
      @user.avatar.purge if params[:user][:remove_avatar] == "1"

      if @user.update(user_params)
        redirect_to admin_user_path(@user), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @user.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_user
      @user = User.find(params[:id])
    end

    def user_params
      params.require(:user).permit(
        :user_name, :avatar, :remove_avatar, :role, :phone_number,
        :email, :first_name, :last_name, :address, :post_code,
        :town, :country, :birth_date, :license_code, :license_number,
        :club_member, :bike_brand, :cylinder_capacity, :stroke_type,
        :club_name, :race_number
      )
    end

    # Couche de sécurité supplémentaire pour rediriger un user qui n'est pas admin
    def ensure_admin
      redirect_to(root_path, alert: "Accès interdit") unless current_user&.admin?
    end
  end
end
