module Members
  class ArticlesController < BaseController
    skip_before_action :authenticate_user!
  end
end
