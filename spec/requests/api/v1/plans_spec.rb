# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Plans", type: :request do
  let!(:plan1) { Plan.create!(name: "Basic", price: 100000) }
  let!(:plan2) { Plan.create!(name: "Pro", price: 200000) }
  let!(:user) { create(:user) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe "GET /api/v1/plans" do
    it "returns all plans" do
      get "/api/v1/plans", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"].size).to eq(2)
    end
  end

  describe "GET /api/v1/plans/:id" do
    it "returns a specific plan" do
      get "/api/v1/plans/#{plan1.id}", headers: headers
      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["name"]).to eq("Basic")
    end

    it "returns 404 if plan not found" do
      get "/api/v1/plans/999", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/plans" do
    let(:valid_params) do
      {
        name: "Premium",
        price: Faker::Number.number(digits: 3),
        job_applications_limit: 10,
        interviews_limit: 5,
        attachments_limit: 3
      }
    end

    let(:invalid_params) do
      {
        name: nil,
        price: Faker::Number.number(digits: 3),
        job_applications_limit: 10
      }
    end

    let(:negative_limit_params) do
      {
        name: "Negative Plan",
        price: Faker::Number.number(digits: 3),
        job_applications_limit: -1, # invalid
        interviews_limit: 5,
        attachments_limit: 3
      }
    end

    it "creates a new plan" do
      expect {
        post "/api/v1/plans", params: valid_params.to_json, headers: headers
      }.to change(Plan, :count).by(1)
      expect(response).to have_http_status(:created)
      json = JSON.parse(response.body)
      expect(json["status"]).to eq("success")
      expect(json["data"]["name"]).to eq("Premium")
    end

    it "returns error if params invalid" do
      post "/api/v1/plans", params: invalid_params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end

    it "returns error if limits are negative" do
      post "/api/v1/plans", params: negative_limit_params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json["error"]).to include("Job applications limit must be greater than or equal to 0")
    end

    it "returns error if limits are negative" do
      params = {
        name: "Negative Limit Plan",
        price: 100,
        job_applications_limit: -1
      }

      post "/api/v1/plans", params: params.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      json = JSON.parse(response.body)
      expect(json["error"]).to include("Job applications limit must be greater than or equal to 0")
    end
  end
end
