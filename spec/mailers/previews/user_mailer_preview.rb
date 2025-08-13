# Preview all emails at http://localhost:3000/rails/mailers/user_mailer_mailer
class UserMailerPreview < ActionMailer::Preview
  def email_verification
    # bikin dummy user untuk preview
    user = User.new(
      first_name: "Jane",
      last_name: "Doe",
      email: "jane@example.com",
      email_verification_token: SecureRandom.hex(16)
    )

    UserMailer.email_verification(user)
  end
end
