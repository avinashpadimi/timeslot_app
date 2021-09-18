class MeetingSerializer < BaseSerializer
  attributes :status

  belongs_to :timeslot
  belongs_to :requester, serializer:  UserSerializer
  belongs_to :receiver, serializer: UserSerializer
end
