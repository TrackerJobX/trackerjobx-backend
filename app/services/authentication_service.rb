# frozen_string_literal: true

class AuthenticationService
  def initialize ;end

  def signup_user(user_params)
    user = User.new(user_params)

    if user.save
      token = JwtLib.encode_jwt(user.id)
      {
        status: :created,
        json: {
          status: "success",
          token: token,
          user: user.slice(:id, :email, :username)
        }
      }
    else
      {
        status: :unprocessable_content,
        json: { errors: user.errors.full_messages }
      }
    end
  end

  def signin_user(email, password)
    user = User.find_by(email: email)

    if user&.authenticate(password)
      token = JwtLib.encode_jwt(user.id)
      {
        status: :ok,
        json: {
          status: "success",
          token: token,
          user: user.slice(:id, :email, :username)
        }
      }
    else
      {
        status: :unauthorized,
        json: { error: "Invalid email or password" }
      }
    end
  end

  def forgot_password_user(email)
    user = User.find_by(email: email)

    unless user
      return {
        status: :not_found,
        json: { error: "Email not found" }
      }
    end

    token = SecureRandom.hex(20)
    user.update!(
      reset_password_token: token,
      reset_password_sent_at: Time.current
    )

    reset_link = "https://yourfrontend.com/reset-password?token=#{token}"

    {
      status: :ok,
      json: {
        status: "success",
        message: "Password reset link sent to #{user.email}",
        reset_link: reset_link
      }
    }
  end
end
