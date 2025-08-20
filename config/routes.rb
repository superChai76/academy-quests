Rails.application.routes.draw do
resources :quests do
  member do
    patch :toggle_done
  end
end

  root "quests#index"
end
