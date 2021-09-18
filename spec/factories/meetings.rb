FactoryBot.define do
  factory :meeting do
    association :event, factory: :event
    association :timeslot, factory: :timeslot
    association :requester, factory: :user
    association :receiver, factory: :user
    status { "pending" }
  end
end
