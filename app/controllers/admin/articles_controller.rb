module Admin
  class ArticlesController < BaseController
    include Paginable
    before_action :set_admin_article, only: %i[show edit update destroy]

    def index
      @articles = Article.order(date: :asc)

      # Recherche
      @articles = @articles.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @articles = @articles.with_attached_image if Gallery.reflect_on_attachment(:images)

      # Pagination Kaminari via concern
      @articles = apply_pagination(@articles)
    end

    def show
      # @article - déjà défini par set_admin_article
    end

    def new
      @article = Article.new
    end

    def create
      @article = Article.new(article_params)
      @article.user = current_user
      if @article.save
        redirect_to admin_article_path(@article), notice: "Article crée avec succès"
      else
        render :new, status: :unprocessable_entity, alert: "Erreur lors de la création de l'article"
      end
    end

    def edit
      # @article - déjà défini par set_admin_article
    end

    def update
      # Supprime l'image existante si l'utilisateur coche la case 'Supprimer l'image'
      @article.image.purge if params[:article][:remove_image] == "1"

      if @article.update(article_params)
        redirect_to admin_article_path(@article), notice: "Modification réussie"
      else
        render :edit, status: :unprocessable_entity, alert: "Erreur lors de la modification"
      end
    end

    def destroy
      @article.destroy
      redirect_to admin_dashboard_path, status: :see_other
    end

    private

    def set_admin_article
      @article = Article.find(params[:id])
    end

    def article_params
      params.require(:article).permit(:title, :content, :date, :image, :remove_image)
    end
  end
end
