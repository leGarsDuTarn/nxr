module Public
  class LegalNoticeController < BaseController
    def show
      @legal_notice = LegalNotice.first_or_initialize
    end
  end
end
