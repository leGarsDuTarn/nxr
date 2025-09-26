module Public
  class PrivacyPolicyController < BaseController
    def show
      @privacy_policy = PrivacyPolicy.first_or_initialize
    end
  end
end
