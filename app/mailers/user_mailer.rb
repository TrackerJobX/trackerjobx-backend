class UserMailer < ApplicationMailer
  default from: "no-reply@trackerjobx.com"

  def email_verification(user)
    @user = user
    @verification_url = "#{ENV['FRONTEND_URL']}/api/v1/auth/verify_email?token=#{user.email_verification_token}"
    mail(to: @user.email, subject: "Email Verification. Please verify your email.")
  end
end
