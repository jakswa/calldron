require 'test_helper'

class RobotsControllerTest < ActionDispatch::IntegrationTest
  test "should get health_check" do
    get robots_health_check_url
    assert_response :success
  end

end
