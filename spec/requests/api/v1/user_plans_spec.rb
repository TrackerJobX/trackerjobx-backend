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
    context "when plan exists" do
      it "purchases a new plan" do
        post "/api/v1/user_plans",
             params: { plan_id: plan.id }.to_json,
             headers: headers

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json["message"]).to eq("Plan purchased successfully")
      end
    end

    context "when plan does not exist" do
      it "returns 404 not found" do
        post "/api/v1/user_plans",
             params: { plan_id: 9999 }.to_json,
             headers: headers

        expect(response).to have_http_status(:not_found)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Plan not found")
      end
    end

    context "when an unexpected error occurs" do
      before do
        allow_any_instance_of(UserPlanService).to receive(:purchase_plan).and_raise(StandardError, "Something went wrong")
      end

      it "returns 422 unprocessable entity" do
        post "/api/v1/user_plans",
             params: { plan_id: plan.id }.to_json,
             headers: headers

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json["error"]).to eq("Something went wrong")
      end
    end
  end
end
