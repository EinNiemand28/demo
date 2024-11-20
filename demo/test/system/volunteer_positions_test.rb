require "application_system_test_case"

class VolunteerPositionsTest < ApplicationSystemTestCase
  setup do
    @volunteer_position = volunteer_positions(:one)
  end

  test "visiting the index" do
    visit volunteer_positions_url
    assert_selector "h1", text: "Volunteer positions"
  end

  test "should create volunteer position" do
    visit volunteer_positions_url
    click_on "New volunteer position"

    fill_in "Description", with: @volunteer_position.description
    fill_in "Event", with: @volunteer_position.event_id
    fill_in "Name", with: @volunteer_position.name
    fill_in "Registration deadline", with: @volunteer_position.registration_deadline
    fill_in "Required number", with: @volunteer_position.required_number
    fill_in "Volunteer hours", with: @volunteer_position.volunteer_hours
    click_on "Create Volunteer position"

    assert_text "Volunteer position was successfully created"
    click_on "Back"
  end

  test "should update Volunteer position" do
    visit volunteer_position_url(@volunteer_position)
    click_on "Edit this volunteer position", match: :first

    fill_in "Description", with: @volunteer_position.description
    fill_in "Event", with: @volunteer_position.event_id
    fill_in "Name", with: @volunteer_position.name
    fill_in "Registration deadline", with: @volunteer_position.registration_deadline.to_s
    fill_in "Required number", with: @volunteer_position.required_number
    fill_in "Volunteer hours", with: @volunteer_position.volunteer_hours
    click_on "Update Volunteer position"

    assert_text "Volunteer position was successfully updated"
    click_on "Back"
  end

  test "should destroy Volunteer position" do
    visit volunteer_position_url(@volunteer_position)
    click_on "Destroy this volunteer position", match: :first

    assert_text "Volunteer position was successfully destroyed"
  end
end
