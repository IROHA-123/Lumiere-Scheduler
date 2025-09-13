require "test_helper"

class Staff::ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get staff_shift_requests_path
    assert_response :redirect
  end

  test "should get create" do
    post staff_shift_requests_path
    assert_response :redirect
  end
end
