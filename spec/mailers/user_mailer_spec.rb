require "rails_helper"

RSpec.describe UserMailer, type: :mailer do
  describe "#email_verification" do
    let(:user) { create(:user, email_verification_token: "abc123") }
    let(:mail) { described_class.email_verification(user) }

    it "renders the subject" do
      expect(mail.subject).to eq("Email Verification. Please verify your email.")
    end

    it "sends to the correct email" do
      expect(mail.to).to eq([ user.email ])
    end

    it "includes the verification link with backend host" do
      verification_url = Rails.application.routes.url_helpers.api_v1_verify_email_url(
        token: user.email_verification_token,
        host: "http://backend.test"
      )
      expect(mail.body.encoded).to include(verification_url)
    end
  end
end
