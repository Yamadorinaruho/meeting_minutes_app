require "test_helper"

class MeetingMinutesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get meeting_minutes_index_url
    assert_response :success
  end

  test "should get show" do
    get meeting_minutes_show_url
    assert_response :success
  end

  test "should get new" do
    get meeting_minutes_new_url
    assert_response :success
  end

  test "should get create" do
    get meeting_minutes_create_url
    assert_response :success
  end

  test "should get edit" do
    get meeting_minutes_edit_url
    assert_response :success
  end

  test "should get update" do
    get meeting_minutes_update_url
    assert_response :success
  end

  test "should get destroy" do
    get meeting_minutes_destroy_url
    assert_response :success
  end
end
