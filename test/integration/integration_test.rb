# frozen_string_literal: true
require "rails_helper"

RSpec.describe "Quests (integration)", type: :request do
  let(:valid_params)   { { quest: { description: "Buy milk", is_done: false } } }
  let(:invalid_params) { { quest: { description: "",        is_done: false } } }

  describe "GET /quests" do
    it "should render index with title and frames" do
      get quests_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include('data-test-id="quests-title"')
      expect(response.body).to include('data-test-id="new-quest-form"')
      expect(response.body).to include('data-test-id="quest-list"')
    end
  end

  describe "POST /quests (HTML)" do
    it "should create a quest and redirect to index" do
      expect { post quests_path, params: valid_params }
        .to change(Quest, :count).by(1)

      expect(response).to have_http_status(:found)
      expect(response).to redirect_to(quests_path)
    end

    it "should reject empty description and re-render the form with 422" do
      expect { post quests_path, params: invalid_params }
        .not_to change(Quest, :count)

      expect(response.status).to eq(422)
      expect(response.body).to include('data-test-id="quest-form"')
      expect(response.body).to include('data-test-id="quest-input"')
    end
  end

  describe "POST /quests (Turbo Stream)" do
    it "should prepend a new quest item to the list" do
      expect {
        post quests_path,
             params: valid_params,
             headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      }.to change(Quest, :count).by(1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      created = Quest.order(:created_at).last
      expect(response.body).to include(%(data-test-id="quest-item-#{created.id}"))
      expect(response.body).to include(created.description)
    end
  end

  describe "PATCH /quests/:id/toggle_done (HTML)" do
    it "should toggle the quest state and redirect to index" do
      quest = Quest.create!(description: "Toggle html", is_done: false)

      patch toggle_done_quest_path(quest)

      expect(response).to redirect_to(quests_path)
      expect(quest.reload.is_done).to be(true)
    end
  end

  describe "PATCH /quests/:id/toggle_done (Turbo Stream)" do
    it "should mark as done and re-render item in the list" do
      quest = Quest.create!(description: "Toggle ts", is_done: false)

      patch toggle_done_quest_path(quest),
            headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(quest.reload.is_done).to be(true)
      expect(response.body).to include(%(data-test-id="quest-item-#{quest.id}"))
      expect(response.body).to include(%(data-test-id="quest-content-#{quest.id}"))
    end

    it "should mark as not done and re-render item at the top" do
      quest = Quest.create!(description: "Back to top", is_done: true)

      patch toggle_done_quest_path(quest),
            headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }

      expect(response).to have_http_status(:ok)
      expect(quest.reload.is_done).to be(false)
      expect(response.body).to include(%(data-test-id="quest-item-#{quest.id}"))
    end
  end

  describe "DELETE /quests/:id (HTML)" do
    it "should destroy the quest and redirect to index" do
      quest = Quest.create!(description: "Delete html", is_done: false)

      expect { delete quest_path(quest) }
        .to change(Quest, :count).by(-1)

      expect(response).to redirect_to(quests_url)
    end
  end

  describe "DELETE /quests/:id (Turbo Stream)" do
    it "should destroy the quest and emit turbo remove action" do
      quest = Quest.create!(description: "Delete ts", is_done: false)

      expect {
        delete quest_path(quest), headers: { "ACCEPT" => "text/vnd.turbo-stream.html" }
      }.to change(Quest, :count).by(-1)

      expect(response).to have_http_status(:ok)
      expect(response.media_type).to eq("text/vnd.turbo-stream.html")
      expect(response.body).to include(%(action="remove"))
      expect(response.body).to include(%(target="quest_#{quest.id}"))
    end
  end
end
