class Meeting < ApplicationRecord
  enum status: %w(pending accepted rejected cancelled rescheduled)

  belongs_to :timeslot, foreign_key: :timeslot_id, primary_key: :id
  belongs_to :event, foreign_key: :event_id, primary_key: :id

  belongs_to :requester, class_name: "User", foreign_key: :requester_id, primary_key: :id
  belongs_to :receiver,  class_name: "User", foreign_key: :receiver_id,  primary_key: :id

  scope :active, -> { where.not(status: ['cancelled','rejected']) }
  scope :by_event, -> (event) { where(event: event) }
  scope :by_requester, ->(user) { where(requester: user) }
  scope :by_receiver, ->(user) { where(receiver: user) }
  
  # Definition of User Meetings:
  #   Any meeting where user is either requester or receiver 
  #
  def self.active_meetings_by_user_event user, event
    Meeting.by_requester(user).or(Meeting.by_receiver(user)).active.by_event(event)
  end
end
