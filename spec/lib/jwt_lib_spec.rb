# frozen_string_literal: true

require 'rails_helper'

RSpec.describe JwtLib do
  let(:user_id) { SecureRandom.uuid }

  describe '.encode_jwt' do
    it 'returns a valid JWT token' do
      token = JwtLib.encode_jwt(user_id)
      expect(token).to be_a(String)
      expect(token.split('.').size).to eq(3) # JWT has 3 parts
    end
  end

  describe '.decode_jwt' do
    it 'decodes the token and returns correct user_id' do
      token = JwtLib.encode_jwt(user_id)
      decoded = JwtLib.decode_jwt(token)
      expect(decoded['user_id']).to eq(user_id)
    end

    it 'raises error when token is invalid' do
      expect {
        JwtLib.decode_jwt('invalid.token.value')
      }.to raise_error(JWT::DecodeError)
    end
  end
end
