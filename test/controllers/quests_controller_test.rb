require "test_helper"

class QuestsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @quest = quests(:one)
  end

  test "should get index" do
    get quests_url
    assert_response :success
    assert_select '[data-test-id="quests-title"]', "Quests"
  end


  test "should create quest with valid params" do
    assert_difference("Quest.count") do
      post quests_url, params: { quest: { description: "New quest", is_done: false } }
    end
    assert_redirected_to quests_path
  end

  test "should not create quest with invalid params" do
    assert_no_difference("Quest.count") do
      post quests_url, params: { quest: { description: "", is_done: false } }
    end
    assert_response :unprocessable_content
  end

  test "should destroy quest" do
    assert_difference("Quest.count", -1) do
      delete quest_url(@quest)
    end
    assert_redirected_to quests_url
  end

  test "should toggle quest done" do
    original = @quest.is_done
    patch toggle_done_quest_url(@quest)
    assert_redirected_to quests_path

    @quest.reload
    assert_equal !original, @quest.is_done
  end

  # Turbo Stream cases
  test "should create quest via turbo_stream" do
    assert_difference("Quest.count") do
      post quests_url(format: :turbo_stream), params: { quest: { description: "Stream quest", is_done: false } }
    end
    assert_response :success
    assert_select '[data-test-id^="quest-item-"]'  # ตรวจว่ามี quest item โผล่มา
  end

  test "should destroy quest via turbo_stream" do
    assert_difference("Quest.count", -1) do
      delete quest_url(@quest, format: :turbo_stream)
    end
    assert_response :success
  end

  test "should toggle quest done via turbo_stream" do
    patch toggle_done_quest_url(@quest, format: :turbo_stream)
    assert_response :success
  end
end
