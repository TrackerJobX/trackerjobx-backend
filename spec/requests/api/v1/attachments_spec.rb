require 'rails_helper'

RSpec.describe "Api::V1::Attachments", type: :request do
  let(:user) { create(:user) }
  let!(:job_application) { create(:job_application) }
  let!(:headers) { auth_headers(user).merge("CONTENT_TYPE" => "application/json") }

  describe 'GET /api/v1/attachments' do
    let!(:user) { create(:user) }
    let!(:job_application) { create(:job_application, user: user) }
    let!(:attachments) { create_list(:attachment, 2, job_application: job_application) }
    let!(:other_user) { create(:user) }
    let!(:other_job_app) { create(:job_application, user: other_user) }
    let!(:other_attachment) { create(:attachment, job_application: other_job_app) }

    before do
      # headers should be authenticated as `user`
      allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user)
    end

    it 'returns attachments for job application belonging to current user' do
      get "/api/v1/attachments", params: { job_application_id: job_application.id }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(2)
    end

    it 'returns empty array if job application does not belong to current user' do
      get "/api/v1/attachments", params: { job_application_id: other_job_app.id }, headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns all attachments for current user when job_application_id is missing' do
      get "/api/v1/attachments", headers: headers
      expect(response).to have_http_status(:ok)
      expect(json_body["data"].size).to eq(2)
      expect(json_body["data"].map { |a| a["id"] }).to match_array(attachments.map(&:id))
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
