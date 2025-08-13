# frozen_string_literal: true

class EmailVerificationService
  def initialize(token)
    @token = token
  end

  def verify_email
    user = User.find_by(email_verification_token: @token)
    return { success: false, error: "Invalid token" } unless user
    return { success: false, error: "Token expired" } if token_expired?(user)

    user.verify_email!
    { success: true, user: user }
  end

  private

  def token_expired?(user)
    user.email_verification_sent_at <= Time.current - 2.days
  end
end
