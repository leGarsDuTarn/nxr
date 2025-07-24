require "test_helper"

class Members::DashboardControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get members_dashboard_index_url
    assert_response :success
  end
end
