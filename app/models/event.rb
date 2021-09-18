class Event < ApplicationRecord
  has_many :timeslots, foreign_key: :event_id, primary_key: :id
end
