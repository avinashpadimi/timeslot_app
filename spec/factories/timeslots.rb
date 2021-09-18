FactoryBot.define do
  factory :timeslot do
    title { Faker::Lorem.word }
    reservable { true }
    association :event, factory: :event
  end
end
