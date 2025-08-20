require "application_system_test_case"

class QuestsTest < ApplicationSystemTestCase
  setup do
    @quest = quests(:one)
  end

  test "visiting the index" do
    visit quests_url
    assert_selector "h1", text: "Quests"
  end

  test "should create quest" do
    visit quests_url
    click_on "New quest"

    fill_in "Description", with: @quest.description
    check "Is done" if @quest.is_done
    click_on "Create Quest"

    assert_text "Quest was successfully created"
    click_on "Back"
  end

  test "should update Quest" do
    visit quest_url(@quest)
    click_on "Edit this quest", match: :first

    fill_in "Description", with: @quest.description
    check "Is done" if @quest.is_done
    click_on "Update Quest"

    assert_text "Quest was successfully updated"
    click_on "Back"
  end

  test "should destroy Quest" do
    visit quest_url(@quest)
    accept_confirm { click_on "Destroy this quest", match: :first }

    assert_text "Quest was successfully destroyed"
  end
end
