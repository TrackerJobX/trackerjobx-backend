require "rails_helper"

RSpec.describe "Api::V1::UserPlans", type: :request do
  let(:user) { create(:user) }
  let(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }
  let!(:plan) { create(:plan, price: 100) }

  describe "GET /api/v1/user_plans" do
    let!(:user_plan) { create(:user_plan, user: user, plan: plan, status: "active") }

    it "returns the user's plans" do
      get "/api/v1/user_plans", headers: headers

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"].first["status"]).to eq("active")
    end
  end

  describe "POST /api/v1/user_plans" do
    let!(:plan) { create(:plan) } # ini penting, bikin plan dulu sebelum dipakai

    context "when user is admin" do
      let!(:admin) { create(:user, role: "admin") }
      let!(:headers) { auth_headers(admin) }
      let!(:member) { create(:user, role: "member") }

      it "creates a new active plan with admin" do
        post "/api/v1/user_plans",
            params: { plan_id: plan.id, user_id: member.id, status: "active" },
            headers: headers,
            as: :json

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Plan purchased successfully")
      end
    end

    context "when plan not found" do
      it "returns not found" do
        post "/api/v1/user_plans",
            params: { plan_id: 0, user_id: user.id, status: "active" },
            headers: headers,
            as: :json

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Plan not found")
      end
    end
  end
end
