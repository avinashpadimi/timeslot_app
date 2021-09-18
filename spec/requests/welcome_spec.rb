require 'rails_helper'
RSpec.describe "Welcome spec", type: :request do

  describe "GET /welcome" do
    it "should return 401 unauthorized when authentication header is not provided" do
      get welcome_index_path
      expect(response.status).to eq 401
    end

    context "with the correct authentication header" do
      let!(:user){ create(:user) }

      it "should return with correct status code and respond with serialized user data" do
        get(welcome_index_path, headers: {'Authorization': user.id})
        expect(response.status).to eq 200
        expect(response_data_attributes["first_name"]).to eq(user.first_name)
      end
    end
  end
end
