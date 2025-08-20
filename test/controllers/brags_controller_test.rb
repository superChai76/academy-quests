require "test_helper"

class BragControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quest = quests(:one)
  end

  test "should get index" do
    get brags_url
    assert_response :success
    assert_select '[data-test-id="brag-title"]', "My Brag Document"
  end
end