class User < ApplicationRecord
  has_many :timeslot_bookmarks, foreign_key: :user_id, primary_key: :id
  has_many :timeslots, through: :timeslot_bookmarks
end
