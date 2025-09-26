module Public
  class LegalNoticeController < BaseController
    def show
      @legal_notice = LegalNotice.first
    end
  end
end
