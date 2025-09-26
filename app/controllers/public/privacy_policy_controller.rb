module Public
  class PrivacyPolicyController < BaseController
    def show
      @privacy_policy = PrivacyPolicy.first
    end
  end
end
