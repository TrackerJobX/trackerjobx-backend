require 'rails_helper'

RSpec.describe "Api::V1::JobApplications", type: :request do
  let!(:user) { create(:user) }
  before { create_list(:job_application, 3, user: user) }
  let!(:other_user) { create(:user) }
  let!(:others_applications) { create_list(:job_application, 2, user: other_user) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe 'GET /api/v1/job_applications' do
    it 'returns current user’s job applications only' do
      get "/api/v1/job_applications", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(3)
    end

    it 'paginates job applications' do
      get "/api/v1/job_applications?page=1&per_page=2", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(2)
    end

    it 'returns empty array if pagination is out of range' do
      get "/api/v1/job_applications?page=99&per_page=10", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]).to eq([])
    end

    it 'handles invalid pagination params gracefully' do
      get "/api/v1/job_applications?page=-1&per_page=-5", headers: headers
      expect(response).to have_http_status(:ok) # atau :bad_request sesuai implementasi kamu
      expect(json_body["data"]).to be_a(Array)
    end

    it 'returns unauthorized without auth token' do
      get "/api/v1/job_applications"
      expect(response).to have_http_status(:unauthorized)
    end

    context 'when user has no job applications' do
      let(:empty_user) { create(:user) }
      let(:empty_headers) { auth_headers(empty_user) }

      it 'returns an empty list' do
        get "/api/v1/job_applications", headers: empty_headers
        expect(response).to have_http_status(:ok)
        expect(json_body["data"]).to eq([])
      end
    end
  end

  describe 'GET /api/v1/job_applications/:id' do
    let!(:job_app) { create(:job_application, user: user) }

    it 'returns a specific job application' do
      get "/api/v1/job_applications/#{job_app.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]["id"]).to eq(job_app.id)
    end

    it 'returns 404 if not found' do
      get "/api/v1/job_applications/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'POST /api/v1/job_applications' do
    let!(:invalid_headers) { auth_headers(other_user) }
    it 'creates a job application with minimal required fields' do
      params = {
        company_name: "Binar Academy",
        position_title: "Fullstack Dev",
        application_link: "https://form.gle/binar",
        status: "applied"
      }

      post "/api/v1/job_applications", params: params.to_json, headers: headers
      expect(response).to have_http_status(:created)
      expect(json_body["data"]["company_name"]).to eq("Binar Academy")
    end

    it 'returns error for invalid status' do
      params = {
        company_name: "Company X",
        position_title: "Dev",
        status: "notreal"
      }

      post "/api/v1/job_applications", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end

    it 'returns error if user_id is invalid' do
      params = {
        company_name: "Company Y",
        position_title: "Dev",
        status: "draft"
      }

      post "/api/v1/job_applications", params: params.to_json, headers: invalid_headers
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end
  end

  describe 'PUT /api/v1/job_applications/:id' do
    let!(:job_app) { create(:job_application, user: user) }

    it 'updates a job application' do
      put "/api/v1/job_applications/#{job_app.id}",
          params: { company_name: "Updated Co" }.to_json, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]["company_name"]).to eq("Updated Co")
    end

    it 'returns error when update is invalid' do
      put "/api/v1/job_applications/#{job_app.id}",
          params: { status: "invalid" }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end

    it 'returns 404 when updating non-existent id' do
      put "/api/v1/job_applications/#{SecureRandom.uuid}",
          params: { company_name: "Doesn't Exist" }.to_json, headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error when status is invalid' do
      put "/api/v1/job_applications/#{job_app.id}",
          params: { status: "notreal" }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_body["status"]).to eq("error")
    end

    it 'returns error when company_name is blank' do
      put "/api/v1/job_applications/#{job_app.id}",
          params: { company_name: "" }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_body["status"]).to eq("error")
    end

    it 'returns error when job application not found' do
      put "/api/v1/job_applications/#{SecureRandom.uuid}",
          params: { company_name: "Ghost Update" }.to_json, headers: headers

      expect(response).to have_http_status(:not_found)
      expect(json_body["status"]).to eq("error")
      expect(json_body["message"]).to eq("Not Found")
    end

    it 'returns error when required field is missing' do
      put "/api/v1/job_applications/#{job_app.id}",
          params: { company_name: nil }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
      expect(json_body["status"]).to eq("error")
      expect(json_body["message"]).to match(/can't be blank/)
    end
  end

  describe 'DELETE /api/v1/job_applications/:id' do
    let!(:job_app) { create(:job_application, user: user) }

    it 'deletes the job application' do
      delete "/api/v1/job_applications/#{job_app.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if trying to delete non-existent resource' do
      delete "/api/v1/job_applications/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
