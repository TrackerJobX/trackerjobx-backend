class UserMailer < ApplicationMailer
  default from: "no-reply@trackerjobx.com"

  def email_verification(user)
    @user = user
    @verification_url = api_v1_verify_email_url(token: user.email_verification_token)
    mail(to: @user.email, subject: "Email Verification. Please verify your email.")
  end
end
