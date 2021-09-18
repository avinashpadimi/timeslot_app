require 'rails_helper'

RSpec.describe "Timeslots", type: :request do
  describe "GET /index" do
    it "should return 401 unauthorized when authentication header is not provided" do
      get '/events/1/timeslots'
      expect(response.status).to eq 401
    end

    context "with the correct authentication header" do
      let!(:user1){ create(:user) }

      it "should return 403 forbidden when event id is not valid" do 
        get '/events/1/timeslots', headers: {'Authorization': user1.id}
        expect(response.status).to eq 403
        expected_resp = {  "message" => "Forbidden", "code" =>  403 }
        expect(JSON.parse(response.body)).to match(expected_resp)
      end
    end

    context "Event TimeSlots" do 
      let!(:user2) { create(:user) }
      let!(:event1) { create(:event) }
      let!(:event2) { create(:event) }
      let!(:timeslot1) { create(:timeslot, event: event1) }
      let!(:timeslot2) { create(:timeslot, event: event1) }
      let!(:timeslot3) { create(:timeslot, event: event2) }

      it "should return all the timeslots of an event" do 
        get "/events/#{event1.id}/timeslots", headers: {'Authorization': user2.id}
        expect(response.status).to eq 200
        expected_resp = {"data"=>
                         [{"id"=> timeslot1.id.to_s, "type"=>"timeslot", "attributes"=>{"title"=> timeslot1.title, "reservable"=> timeslot1.reservable}, 
                           "relationships"=>{"meetings"=>{"data"=>[]}, "users"=>{"data"=>[]}}},
                         {"id"=> timeslot2.id.to_s, "type"=>"timeslot", "attributes"=>{"title"=> timeslot2.title, "reservable"=> timeslot2.reservable}, 
                           "relationships"=>{"meetings"=>{"data"=>[]}, "users"=>{"data"=>[]}}}],
                         "included"=>[]}
        expect(JSON.parse(response.body)).to match(expected_resp)
      end

      context "Event TimeSlots with BookMaraked Users" do 
        let!(:user3) { create(:user) }
        let!(:bookmark1) { create(:timeslot_bookmark, user: user2, timeslot: timeslot1) }
        let!(:bookmark2) { create(:timeslot_bookmark, user: user3, timeslot: timeslot1) }
        
        it "should return all the timeslots of an event and bookmarked users info" do 
          get "/events/#{event1.id}/timeslots", headers: {'Authorization': user2.id}
          expect(response.status).to eq 200
          expected_resp = {"data"=>
                           [{"id"=> timeslot1.id.to_s, "type"=>"timeslot", "attributes"=>{"title"=> timeslot1.title, "reservable"=> timeslot1.reservable}, 
                             "relationships"=>{"meetings"=>{"data"=>[]}, "users"=>{"data"=>[{ "id" =>  user2.id.to_s, "type" => 'user' },{ "id" =>  user3.id.to_s, "type" => 'user'}]}}},
                           {"id"=> timeslot2.id.to_s, "type"=>"timeslot", "attributes"=>{"title"=> timeslot2.title, "reservable"=> timeslot2.reservable}, 
                            "relationships"=>{"meetings"=>{"data"=>[]}, "users"=>{"data"=>[]}}}],
                           "included"=>[
                             {
                               "id"=>user2.id.to_s, 
                               "type"=>"user", 
                               "attributes"=>
                               {
                                 "firstName"=> user2.first_name, 
                                 "lastName"=> user2.last_name, 
                                 "companyName"=> user2.company_name, 
                                 "companyTitle"=> user2.company_title
                               }
                             }, 
                             {
                               "id"=>user3.id.to_s,
                               "type"=>"user", 
                               "attributes"=>
                               {
                                 "firstName"=> user3.first_name, 
                                 "lastName"=> user3.last_name, 
                                 "companyName"=> user3.company_name, 
                                 "companyTitle"=> user3.company_title
                               }
                             } ] }
          expect(JSON.parse(response.body)).to match(expected_resp)
        end

        context "Event Timeslots with BookMarked Users and Associated Meetings" do 
          let!(:user4) { create(:user) }
          let!(:meeting1) { create(:meeting, event: event1, timeslot: timeslot1, requester: user2, receiver: user4,status: 'pending')}
          let!(:meeting2) { create(:meeting, event: event1, timeslot: timeslot2, requester: user3, receiver: user2,status: 'pending')}
          let!(:meeting3) { create(:meeting, event: event1, timeslot: timeslot2, requester: user2, receiver: user3,status: 'cancelled')}
          let!(:meeting4) { create(:meeting, event: event1, timeslot: timeslot2, requester: user3, receiver: user4,status: 'pending')}

          it "should return Associated meetings of the logged in user (cancelled meeting shoudn't come)" do 
            get "/events/#{event1.id}/timeslots", headers: {'Authorization': user2.id}
            expect(response.status).to eq 200
            expected_resp = {
              "data"=> [
                {
                  "id"=> timeslot1.id.to_s, 
                  "type"=>"timeslot", 
                  "attributes"=>
                  {
                    "title"=> timeslot1.title, 
                    "reservable"=> timeslot1.reservable
                  }, 
                  "relationships"=> {
                    "meetings"=>
                    {
                      "data"=>[ {
                        "id" => meeting1.id.to_s,
                        "type" => "meeting"
                      }]
                    }, 
                    "users"=>
                    {
                      "data"=>[
                        { 
                          "id" =>  user2.id.to_s,
                          "type" => 'user' 
                        },
                        { 
                          "id" =>  user3.id.to_s, 
                          "type" => 'user'}
                      ]
                    }}},
                    {
                      "id"=> timeslot2.id.to_s,
                      "type"=>"timeslot", 
                      "attributes"=>
                      {
                        "title"=> timeslot2.title, 
                        "reservable"=> timeslot2.reservable}, 
                        "relationships"=>
                        {
                          "meetings"=>
                          {
                            "data"=>[
                              {
                                "id" => meeting2.id.to_s,
                                "type" => "meeting"
                              }
                            ]
                          }, 
                          "users"=>
                          {
                            "data"=>[]}}}]
            }
            included_resp = [{

            }]


            included_resp = [{"id"=>meeting1.id.to_s,
                              "type"=>"meeting",
                              "attributes"=>{"status"=> meeting1.status},
                              "relationships"=>{"timeslot"=>{"data"=>{"id"=> timeslot1.id.to_s, "type"=>"timeslot"}}, "requester"=>{"data"=>{"id"=> user2.id.to_s, "type"=>"user"}}, "receiver"=>{"data"=>{"id"=>user4.id.to_s, "type"=>"user"}}}},
            {"id"=> user2.id.to_s, "type"=>"user", "attributes"=>{"firstName"=> user2.first_name, "lastName"=> user2.last_name, "companyName"=> user2.company_name, "companyTitle"=> user2.company_title}},
            {"id"=> user3.id.to_s, "type"=>"user", "attributes"=>{"firstName"=> user3.first_name, "lastName"=> user3.last_name, "companyName"=> user3.company_name, "companyTitle"=> user3.company_title}},
            {"id"=> meeting2.id.to_s,
             "type"=>"meeting",
             "attributes"=>{"status"=> meeting2.status},
             "relationships"=>{"timeslot"=>{
               "data"=>{"id"=> timeslot2.id.to_s, "type"=>"timeslot"}}, "requester"=>{"data"=>{"id"=> user3.id.to_s, "type"=>"user"}}, 
             "receiver"=>{"data"=>{"id"=> user2.id.to_s, "type"=>"user"}}}}]

            resp = JSON.parse(response.body)
            expect(resp.except("included")).to match(expected_resp)
            expect(resp["included"]).to match_array(included_resp)
          end
        end
      end
    end
  end
end
