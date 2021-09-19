require 'rails_helper'

RSpec.describe TimeslotListService, :type => :model do
  describe "List Timeslots" do 
    context "Error Scenario" do 
      it "should return error if user or event doesnt exist" do 
        service = TimeslotListService.new({ event: nil, user: nil})
        resp = service.call
        expect(resp.success).to be_falsey
        expect(resp.error[:message]).to eq("UnprocessableEntity")

        user = double(:user)
        service = TimeslotListService.new({ event: nil, user: user})
        resp = service.call
        expect(resp.success).to be_falsey
        expect(resp.error[:message]).to eq("UnprocessableEntity")
      end
    end

    context "Timeslots List" do 
      let!(:user1) { create(:user) } 
      let!(:event1) { create(:event) }

      it "should return empty list if no timeslots exists" do 
        service = TimeslotListService.new({ event: event1, user: user1})
        resp = service.call
        expect(resp.success).to be_truthy
        expect(resp.payload[:timeslots].count).to eq(0)
      end

      it "should return list of timeslots and associated meetings (Cancelled meetings shouldn't come)" do 
       timeslot1 =  create(:timeslot, event: event1)
       timeslot2 =  create(:timeslot, event: event1)
       user2 = create(:user)
       user3 = create(:user)

       meeting1 = create(:meeting, event: event1, timeslot: timeslot1, requester: user2, receiver: user1,status: 'pending')
       meeting2 = create(:meeting, event: event1, timeslot: timeslot1, requester: user2, receiver: user3,status: 'cancelled')
       meeting3 = create(:meeting, event: event1, timeslot: timeslot2, requester: user1, receiver: user3,status: 'pending')

        service = TimeslotListService.new({ event: event1, user: user2})
        resp = service.call
        expect(resp.success).to be_truthy
        timeslots = resp.payload[:timeslots]

        expect(timeslots.count).to eq(2)
        meetings = timeslots.map(&:meetings).flatten
        expect(meetings).to match_array([meeting1])
      end
    end
  end
end
