Rails.application.routes.draw do
  get "brag/index"
  resources :quests, only: [ :index ] do
  member { patch :toggle_done }
end

  get "/brags", to: "brags#index"

  root "quests#index"
end
