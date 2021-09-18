class TimeslotBookmark < ApplicationRecord
  belongs_to :timeslot, foreign_key: :timeslot_id, primary_key: :id
  belongs_to :user, foreign_key: :user_id, primary_key: :id
end
