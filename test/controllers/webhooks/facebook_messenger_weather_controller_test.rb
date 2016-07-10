require 'test_helper'

class Webhooks::FacebookMessengerWeatherControllerTest < ActionController::TestCase
  test "should get verify" do
    get :verify
    assert_response :success
  end

  test "should get chat" do
    get :chat
    assert_response :success
  end

end
