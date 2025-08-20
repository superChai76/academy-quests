# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Quests", type: :system do
  before { driven_by :selenium_chrome_headless }

  it "should show quest form on index" do
    visit quests_path
    expect(page).to have_css("form[data-test-id='quest-form']")
    expect(page).to have_css("input[data-test-id='quest-input']")
    expect(page).to have_css("button[data-test-id='quest-submit-btn']")
    expect(page).to have_css("[data-test-id='quest-list']") # turbo-frame
  end

  it "should create quest from form" do
    visit quests_path

    within "[data-test-id='new-quest-form']" do
      fill_in "quest_description", with: "Learn Rails system tests"
      find("button[data-test-id='quest-submit-btn']").click
    end

    # รอ Turbo ใส่ item เข้า list
    within "[data-test-id='quest-list']" do
      expect(page).to have_text("Learn Rails system tests")
      expect(page).to have_css("[data-test-id^='quest-item-']")
    end
  end

  it "should not create empty quest" do
    visit quests_path

    # จับจำนวนรายการใน list (ภายใน turbo-frame) ก่อน/หลัง
    within "[data-test-id='quest-list']" do
      before_count = page.all("[data-test-id^='quest-item-']").size

      within :xpath, "//*[@data-test-id='new-quest-form']" do
        # ให้ชัวร์ว่า input ว่าง
        find("input[data-test-id='quest-input']").set("")
        find("button[data-test-id='quest-submit-btn']").click
      end

      # ควรเท่าเดิม (Turbo จะรีเฟรชเฉพาะฟอร์ม ไม่แตะ list)
      expect(page).to have_css("[data-test-id^='quest-item-']", count: before_count)
    end
  end

  it "should toggle quest done state" do
    visit quests_path

    # สร้างรายการก่อน
    within "[data-test-id='new-quest-form']" do
      fill_in "quest_description", with: "Toggle me"
      find("button[data-test-id='quest-submit-btn']").click
    end

    # หา id ของรายการจาก data-test-id
    within "[data-test-id='quest-list']" do
      item = find("[data-test-id^='quest-item-']", text: "Toggle me", match: :first)
      quest_id = item["data-test-id"].split("-").last

      # คลิก checkbox (ต้องใช้ JS driver)
      find("input[data-test-id='quest-done-checkbox-#{quest_id}']", visible: :all).click

      # หลัง Turbo อัปเดต: span เนื้อหา จะมี class line-through (เช็คง่ายกว่า opacity-40)
      expect(page).to have_css("[data-test-id='quest-content-#{quest_id}'].line-through")
    end
  end

  it "should delete quest" do
    visit quests_path

    # สร้างรายการก่อน
    within "[data-test-id='new-quest-form']" do
      fill_in "quest_description", with: "Delete me"
      find("button[data-test-id='quest-submit-btn']").click
    end

    within "[data-test-id='quest-list']" do
      item = find("[data-test-id^='quest-item-']", text: "Delete me", match: :first)
      quest_id = item["data-test-id"].split("-").last

      find("[data-test-id='quest-delete-btn-#{quest_id}']").click
      expect(page).to have_no_css("[data-test-id='quest-item-#{quest_id}']")
      expect(page).to have_no_text("Delete me")
    end
  end
end
