require "test_helper"

class VolunteerPositionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @volunteer_position = volunteer_positions(:one)
  end

  test "should get index" do
    get volunteer_positions_url
    assert_response :success
  end

  test "should get new" do
    get new_volunteer_position_url
    assert_response :success
  end

  test "should create volunteer_position" do
    assert_difference("VolunteerPosition.count") do
      post volunteer_positions_url, params: { volunteer_position: { description: @volunteer_position.description, event_id: @volunteer_position.event_id, name: @volunteer_position.name, registration_deadline: @volunteer_position.registration_deadline, required_number: @volunteer_position.required_number, volunteer_hours: @volunteer_position.volunteer_hours } }
    end

    assert_redirected_to volunteer_position_url(VolunteerPosition.last)
  end

  test "should show volunteer_position" do
    get volunteer_position_url(@volunteer_position)
    assert_response :success
  end

  test "should get edit" do
    get edit_volunteer_position_url(@volunteer_position)
    assert_response :success
  end

  test "should update volunteer_position" do
    patch volunteer_position_url(@volunteer_position), params: { volunteer_position: { description: @volunteer_position.description, event_id: @volunteer_position.event_id, name: @volunteer_position.name, registration_deadline: @volunteer_position.registration_deadline, required_number: @volunteer_position.required_number, volunteer_hours: @volunteer_position.volunteer_hours } }
    assert_redirected_to volunteer_position_url(@volunteer_position)
  end

  test "should destroy volunteer_position" do
    assert_difference("VolunteerPosition.count", -1) do
      delete volunteer_position_url(@volunteer_position)
    end

    assert_redirected_to volunteer_positions_url
  end
end
