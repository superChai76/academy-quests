json.extract! quest, :id, :description, :is_done, :created_at, :updated_at
json.url quest_url(quest, format: :json)
