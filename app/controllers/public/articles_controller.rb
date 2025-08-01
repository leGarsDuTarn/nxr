module Public
  class ArticlesController < BaseController
    def index
      @articles = Article.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @article = Article.find(params[:id])
    end
  end
end
