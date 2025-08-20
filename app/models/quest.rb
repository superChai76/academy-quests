class Quest < ApplicationRecord
  validates :description, presence: true
end
