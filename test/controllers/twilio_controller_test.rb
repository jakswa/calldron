require 'test_helper'

class TwilioControllerTest < ActionDispatch::IntegrationTest
  test "should get route" do
    get twilio_route_url
    assert_response :success
  end

  test "should get status" do
    get twilio_status_url
    assert_response :success
  end

end
