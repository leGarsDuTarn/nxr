module Members
  class ArticlesController < BaseController
    skip_before_action :authenticate_user! # Permet de rendre la page public sans création de compte

    def index
      @articles = Article.all.order(created_at: :desc) # :desc -> + récent en premier
    end

    def show
      @article = Article.find(params[:id])
    end
  end
end
