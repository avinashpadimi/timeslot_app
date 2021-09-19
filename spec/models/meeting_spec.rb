require 'rails_helper'

RSpec.describe Meeting, type: :model do
  describe "Active Meeting" do 
    context "By User and Event" do
      let!(:user1) { create(:user) }
      let!(:user2) { create(:user) }
      let!(:user3) { create(:user) }
      let!(:event1) { create(:event) }
      let!(:event2) { create(:event) }
      let!(:timeslot1) { create(:timeslot, event: event1) }
      let!(:timeslot2) { create(:timeslot, event: event2) }
      let!(:meeting1) { create(:meeting, event: event1, timeslot: timeslot1, requester: user1, receiver: user2,status: 'pending')}
      let!(:meeting2) { create(:meeting, event: event1, timeslot: timeslot2, requester: user2, receiver: user1,status: 'pending')}
      let!(:meeting3) { create(:meeting, event: event1, timeslot: timeslot2, requester: user3, receiver: user1,status: 'cancelled')}
      let!(:meeting4) { create(:meeting, event: event2, timeslot: timeslot2, requester: user1, receiver: user3,status: 'pending')}

      it "should return active meetings of a user in a specific event" do 
        meetings = Meeting.active_meetings_by_user_event(user1,event1)

        meeting_ids = [meeting1.id, meeting2.id]
        expect(meetings.ids).to eq(meeting_ids)
      end
    end
  end
end
