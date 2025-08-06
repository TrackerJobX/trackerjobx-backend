require 'rails_helper'

RSpec.describe "Api::V1::Tags", type: :request do
  let(:headers) { { 'ACCEPT' => 'application/json' } }

  describe 'GET /tags' do
    it 'returns list of tags' do
      create_list(:tag, 2)
      get '/api/v1/tags', headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].size).to eq(2)
    end

    it 'return with pagination tags' do
      create_list(:tag, 10)
      get '/api/v1/tags', params: { page: 1, per_page: 5 }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data'].size).to eq(5)
    end
  end

  describe 'POST /tags' do
    it 'creates a tag with valid params' do
      post '/api/v1/tags', params: { name: 'Frontend' }, headers: headers
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['data']['name']).to eq('Frontend')
    end

    it 'returns error with invalid params' do
      post '/api/v1/tags', params: { name: '' }, headers: headers
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end
  end

  describe 'GET /tags/:id' do
    it 'shows a tag' do
      tag = create(:tag)
      get "/api/v1/tags/#{tag.id}", headers: headers
      expect(response).to have_http_status(:ok)
    end

    it 'returns 404 if tag not found' do
      get "/api/v1/tags/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end

  describe 'PUT /tags/:id' do
    it 'updates a tag' do
      tag = create(:tag, name: 'OldName')
      put "/api/v1/tags/#{tag.id}", params: { name: 'NewName' }, headers: headers
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['data']['name']).to eq('NewName')
    end

    it 'returns 404 if tag not found' do
      put "/api/v1/tags/#{SecureRandom.uuid}", params: { name: 'NewName' }, headers: headers
      expect(response).to have_http_status(:not_found)
    end

    it 'returns error if update params invalid' do
      tag = create(:tag)
      put "/api/v1/tags/#{tag.id}", params: { name: '' }, headers: headers
      expect(response).to have_http_status(:unprocessable_content).or have_http_status(:bad_request)
    end
  end

  describe 'DELETE /tags/:id' do
    it 'soft deletes a tag' do
      tag = create(:tag)
      delete "/api/v1/tags/#{tag.id}", headers: headers
      expect(response).to have_http_status(:no_content)
    end

    it 'returns 404 if tag not found' do
      delete "/api/v1/tags/#{SecureRandom.uuid}", headers: headers
      expect(response).to have_http_status(:not_found)
    end
  end
end
