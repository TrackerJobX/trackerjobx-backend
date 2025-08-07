module AuthHelper
  def auth_headers(user)
    token = JwtLib.encode_jwt(user.id)
    {
      'AUTHORIZATION' => "Bearer #{token}"
    }
  end
end
