# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Api::AuthController', type: :request do
  describe 'POST /api/v1/auth/signup' do
    context 'with valid params' do
      let(:valid_params) do
        {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          first_name: 'Test',
          last_name: 'User'
        }
      end

      it 'creates a new user and returns token' do
        post '/api/v1/auth/signup', params: valid_params

        expect(response).to have_http_status(:created)
        json = JSON.parse(response.body)
        expect(json['status']).to eq('success')
        expect(json['token']).to be_present
        expect(json['user']['email']).to eq('test@example.com')
      end
    end

    context 'with invalid params' do
      it 'returns errors' do
        post '/api/v1/auth/signup', params: { email: '', password: '' }

        expect(response).to have_http_status(:unprocessable_content)
        json = JSON.parse(response.body)
        expect(json['errors']).to be_an(Array)
      end
    end
  end

  describe 'POST /api/v1/auth/signin' do
    let!(:user) { User.create!(email: 'signin@example.com', password: 'password', password_confirmation: 'password') }

    it 'signs in with correct credentials' do
      post '/api/v1/auth/signin', params: { email: 'signin@example.com', password: 'password' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['token']).to be_present
    end

    it 'fails with wrong password' do
      post '/api/v1/auth/signin', params: { email: 'signin@example.com', password: 'wrong' }

      expect(response).to have_http_status(:unauthorized)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Invalid email or password')
    end
  end

  describe 'POST /api/v1/auth/forgot_password' do
    let!(:user) { User.create!(email: 'forgot@example.com', password: '12345678', password_confirmation: '12345678') }

    it 'sends reset password link if email exists' do
      post '/api/v1/auth/forgot_password', params: { email: 'forgot@example.com' }

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['reset_link']).to include('reset-password?token=')
    end

    it 'returns error if email not found' do
      post '/api/v1/auth/forgot_password', params: { email: 'notfound@example.com' }

      expect(response).to have_http_status(:not_found)
      json = JSON.parse(response.body)
      expect(json['error']).to eq('Email not found')
    end
  end

  describe 'GET /api/v1/auth/profile' do
    let!(:user) { User.create!(email: 'profile@example.com', first_name: 'John', last_name: 'Doe', password: '12345678', password_confirmation: '12345678') }

    it 'returns user details' do
      get '/api/v1/auth/profile', headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['data']['email']).to eq('profile@example.com')
      expect(json['data']['first_name']).to eq('John')
      expect(json['data']['last_name']).to eq('Doe')
    end

    it 'returns user details with member' do
      get '/api/v1/auth/profile', headers: auth_headers(user)

      expect(response).to have_http_status(:ok)
      json = JSON.parse(response.body)
      expect(json['status']).to eq('success')
      expect(json['data']['email']).to eq('profile@example.com')
      expect(json['data']['first_name']).to eq('John')
      expect(json['data']['last_name']).to eq('Doe')
      expect(json['data']['role']).to eq('member')
    end

    it 'returns error if not authenticated' do
      get '/api/v1/auth/profile'
    end
  end
end
