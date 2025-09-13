require "test_helper"

class Staff::ShiftRequestsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get staff_shift_requests_index_url
    assert_response :success
  end

  test "should get create" do
    get staff_shift_requests_create_url
    assert_response :success
  end
end
