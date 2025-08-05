module JwtLib
  def self.encode_jwt(user_id)
    payload = { user_id:, exp: 24.hours.from_now.to_i }
    JWT.encode(payload, Rails.application.credentials.secret_key_base)
  end

  def self.decode_jwt(token)
    JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
  end
end
