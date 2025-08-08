require 'rails_helper'

RSpec.describe "Api::V1::Attachments", type: :request do
  let(:user) { create(:user) }
  let!(:job_application) { create(:job_application) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe 'GET /api/v1/attachments' do
    let!(:job_application) { create(:job_application) }
    before { create_list(:attachment, 2, job_application: job_application) }

    it 'returns list of attachments by job application' do
      get "/api/v1/attachments", params: { job_application_id: job_application.id }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(2)
    end

    it 'returns list of attachment when job application id is missing' do
      get "/api/v1/attachments", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(2)
    end
  end

  describe 'GET /api/v1/attachments/:id' do
    let!(:attachment) { create(:attachment, job_application: job_application) }

    it 'returns the attachment by ID' do
      get "/api/v1/attachments/#{attachment.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"]["id"]).to eq(attachment.id)
    end
  end

  describe 'POST /api/v1/attachments' do
    it 'creates an attachment' do
      params = {
        job_application_id: job_application.id,
        attachment_type: 'cover_letter',
        attachment_url: 'https://example.com/cover.pdf',
        version: 'v1.0'
      }

      post "/api/v1/attachments", params: params.to_json, headers: headers
      expect(response).to have_http_status(:created)
      expect(json_body["data"]["attachment_type"]).to eq("cover_letter")
    end

    it 'returns error for missing job_application_id' do
      post "/api/v1/attachments", params: { attachment_url: 'https://example.com' }.to_json, headers: headers
      expect(response).to have_http_status(:unprocessable_content)
    end
  end

  describe 'DELETE /api/v1/attachments/:id' do
    let!(:attachment) { create(:attachment, job_application: job_application) }

    it 'deletes the attachment' do
      delete "/api/v1/attachments/#{attachment.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if attachment not found' do
      delete "/api/v1/attachments/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
