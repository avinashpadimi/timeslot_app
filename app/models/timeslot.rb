class Timeslot < ApplicationRecord
  belongs_to :event, foreign_key: :event_id, primary_key: :id
  has_many :meetings, -> { where.not(status: ['cancelled','rejected']) },  foreign_key: :timeslot_id, primary_key: :id
  has_many :timeslot_bookmarks, foreign_key: :timeslot_id, primary_key: :id
  has_many :users, through: :timeslot_bookmarks

  scope :by_event, -> (event) { where(event: event) }
end
