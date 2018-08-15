require 'test_helper'

class RegisterControllerTest < ActionDispatch::IntegrationTest
  test "should get info" do
    get register_info_url
    assert_response :success
  end

end
