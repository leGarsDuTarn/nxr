module Admin
  class ArticlesController < BaseController
    before_action :set_admin_article, only: %i[show edit update destroy]

    def index
      @articles = Article.all
    end
  end
end
