require 'rails_helper'

RSpec.describe "Api::V1::Interviews", type: :request do
  let!(:user) { create(:user) }
  let!(:job_application) { create(:job_application) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe 'GET /api/v1/interviews' do
    before { create_list(:interview, 3, job_application: job_application) }

    it 'returns all interviews for a job application' do
      get "/api/v1/interviews", params: { job_application_id: job_application.id }, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(3)
      expect(json_body["data"].map { |i| i["job_application_id"] }.uniq).to eq([ job_application.id ])
    end

    it 'returns empty if no interviews' do
      get "/api/v1/interviews", params: { job_application_id: SecureRandom.uuid }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]).to be_empty
    end
  end


  describe 'POST /api/v1/interviews' do
    it 'creates an interview with valid input' do
      params = {
        job_application_id: job_application.id,
        interview_date: 1.day.from_now,
        location: "Google Meet",
        interview_type: "online",
        notes: "HR screening"
      }

      post "/api/v1/interviews", params: params.to_json, headers: headers
      expect(response).to have_http_status(:created)
      expect(json_body["data"]["location"]).to eq("Google Meet")
    end

    it 'returns error for missing required fields' do
      post "/api/v1/interviews", params: { job_application_id: job_application.id }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'returns error for invalid enum value' do
      params = {
        job_application_id: job_application.id,
        interview_date: Time.current,
        location: "Zoom",
        interview_type: "virtual", # invalid
        notes: "Invalid enum test"
      }

      post "/api/v1/interviews", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
      expect(json_body["status"]).to eq("error")
    end

    it 'returns error if job_application_id does not exist' do
      params = {
        job_application_id: SecureRandom.uuid,
        interview_date: Time.current,
        location: "Phone call",
        interview_type: "phone",
        notes: "Wrong job application"
      }

      post "/api/v1/interviews", params: params.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'GET /api/v1/interviews/:id' do
    let!(:interview) { create(:interview, job_application: job_application) }

    it 'returns interview detail' do
      get "/api/v1/interviews/#{interview.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]["id"]).to eq(interview.id)
    end

    it 'returns 404 if interview not found' do
      get "/api/v1/interviews/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /api/v1/interviews/:id' do
    let!(:interview) { create(:interview, job_application: job_application) }

    it 'updates the interview with valid data' do
      put "/api/v1/interviews/#{interview.id}",
          params: { location: "Updated Location" }.to_json, headers: headers

      expect(response).to have_http_status(:ok)
      expect(json_body["data"]["location"]).to eq("Updated Location")
    end

    it 'returns error for invalid data' do
      put "/api/v1/interviews/#{interview.id}",
          params: { interview_date: nil }.to_json, headers: headers

      expect(response).to have_http_status(:unprocessable_content)
    end

    it 'returns 404 if interview not found' do
      put "/api/v1/interviews/#{SecureRandom.uuid}",
          params: { location: "Ghost Update" }.to_json, headers: headers

      expect(response).to have_http_status(:not_found)
    end
  end


  describe 'DELETE /api/v1/interviews/:id' do
    let!(:interview) { create(:interview, job_application: job_application) }

    it 'deletes the interview' do
      delete "/api/v1/interviews/#{interview.id}", headers: headers
      expect(response).to have_http_status(:no_content)
      expect(Interview.with_deleted.find_by(id: interview.id).deleted?).to be true
    end

    it 'returns 404 if interview not found' do
      delete "/api/v1/interviews/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
