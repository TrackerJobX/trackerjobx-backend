# frozen_string_literal: true

require 'rails_helper'

RSpec.describe AuthenticationService do
  let(:service) { described_class.new }

  describe '#signup_user' do
    context 'when valid user params' do
      let(:user_params) do
        {
          email: 'test@example.com',
          password: 'password123',
          password_confirmation: 'password123',
          first_name: 'Test',
          last_name: 'User'
        }
      end

      it 'creates a user and returns JWT token' do
        result = service.signup_user(user_params)

        expect(result[:status]).to eq(:created)
        expect(result[:data][:status]).to eq('success')
        expect(result[:data][:token]).to be_present
        expect(result[:data][:user][:email]).to eq('test@example.com')
      end
    end

    context 'when invalid user params' do
      let(:user_params) do
        { email: '', password: '', password_confirmation: '' }
      end

      it 'returns errors' do
        result = service.signup_user(user_params)

        expect(result[:status]).to eq(:unprocessable_content)
        expect(result[:data][:errors]).to be_an(Array)
      end
    end
  end

  describe '#signin_user' do
    let!(:user) { User.create!(email: 'user@example.com', password: 'secret123', password_confirmation: 'secret123') }

    context 'with correct credentials' do
      it 'returns success and token' do
        result = service.signin_user('user@example.com', 'secret123')

        expect(result[:status]).to eq(:ok)
        expect(result[:data][:status]).to eq('success')
        expect(result[:data][:token]).to be_present
      end
    end

    context 'with incorrect credentials' do
      it 'returns unauthorized error' do
        result = service.signin_user('user@example.com', 'wrongpass')

        expect(result[:status]).to eq(:unauthorized)
        expect(result[:data][:error]).to eq('Invalid email or password')
      end
    end
  end

  describe '#forgot_password_user' do
    let!(:user) { User.create!(email: 'forgot@example.com', password: 'foobar123', password_confirmation: 'foobar123') }

    context 'when email exists' do
      it 'returns reset link and updates token fields' do
        result = service.forgot_password_user('forgot@example.com')

        expect(result[:status]).to eq(:ok)
        expect(result[:data][:status]).to eq('success')
        expect(result[:data][:reset_link]).to include('https://yourfrontend.com/reset-password?token=')

        user.reload
        expect(user.reset_password_token).to be_present
        expect(user.reset_password_sent_at).to be_present
      end
    end

    context 'when email does not exist' do
      it 'returns not found error' do
        result = service.forgot_password_user('unknown@example.com')

        expect(result[:status]).to eq(:not_found)
        expect(result[:data][:error]).to eq('Email not found')
      end
    end
  end
end
