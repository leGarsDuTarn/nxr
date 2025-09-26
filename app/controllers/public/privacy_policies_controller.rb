module Public
  class PrivacyPoliciesController < BaseController
    def show
      @privacy_policy = PrivacyPolicy.new
    end
  end
end
