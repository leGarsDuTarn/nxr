module Public
  class LegalNoticesController < BaseController
    def show
      @legal_notice = LegalNotice.new
    end
  end
end
