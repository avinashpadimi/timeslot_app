class TimeslotSerializer < BaseSerializer
  attributes :title, :reservable

  has_many :meetings
  has_many :users
end

