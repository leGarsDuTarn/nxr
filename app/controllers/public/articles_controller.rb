module Public
  class ArticlesController < BaseController
    include Paginable
    def index
      @articles = Article.all.order(created_at: :desc) # :desc -> + récent en premier

      # Recherche
      @articles = @articles.search(params[:q]) if params[:q].present?

      # Préchargement ActiveStorage pour éviter les N+1
      @articles = @articles.with_attached_image if Article.reflect_on_attachment(:image)

      # Pagination Kaminari via concern
      @articles = apply_pagination(@articles)
    end

    def show
      @article = Article.find(params[:id])
    end
  end
end
