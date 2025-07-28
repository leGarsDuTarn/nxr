module Members
  class GalleriesController < BaseController
    skip_before_action :authenticate_user!
  end
end
