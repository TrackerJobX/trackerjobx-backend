# frozen_string_literal: true

require 'rails_helper'

RSpec.describe "Api::V1::Users", type: :request do
  let!(:user) { create(:user) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe "GET /api/v1/users" do
    it "returns list of users" do
      get "/api/v1/users", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json[:status]).to eq("success")
      expect(json[:data]).to be_an(Array)
    end
  end

  describe "GET /api/v1/users/:id" do
    it "returns the user details" do
      get "/api/v1/users/#{user.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json[:data][:id]).to eq(user.id)
    end

    it "returns 404 if user not found" do
      get "/api/v1/users/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /api/v1/users" do
    let(:valid_params) {
      attributes_for(:user)
    }

    it "creates a user" do
      post "/api/v1/users", params: valid_params, headers: headers, as: :json
      expect(response).to have_http_status(:created)
      expect(json[:data][:email]).to eq(valid_params[:email])
    end

    it "returns error if params invalid" do
      post "/api/v1/users", params: valid_params.except(:email), headers: headers, as: :json
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end
  end

  describe "PUT /api/v1/users/:id" do
    it "updates user" do
      put "/api/v1/users/#{user.id}", params: { username: "updatedname" }, headers: headers, as: :json
      expect(response).to have_http_status(:ok)
      expect(json[:data][:username]).to eq("updatedname")
    end

    it "returns 404 if user not found" do
      put "/api/v1/users/#{SecureRandom.uuid}", params: { username: "new" }, headers: headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "DELETE /api/v1/users/:id" do
    it "soft deletes user" do
      delete "/api/v1/users/#{user.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it "returns 404 if user not found" do
      delete "/api/v1/users/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
