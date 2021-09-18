FactoryBot.define do
  factory :timeslot_bookmark do
    association :timeslot, factory: :timeslot
    association :user, factory: :user
  end
end
