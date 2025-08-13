require "rails_helper"

RSpec.describe EmailVerificationService, type: :service do
  let(:token) { "abc123" }

  describe "#verify_email" do
    context "when token is valid and not expired" do
      let!(:user) do
        create(:user,
          email_verification_token: token,
          email_verification_sent_at: 1.day.ago
        )
      end

      it "returns success and verifies the email" do
        result = described_class.new(token).verify_email

        expect(result[:success]).to be true
        expect(result[:user]).to eq(user)
        expect(user.reload.email_verification_sent_at).not_to be_nil
      end
    end

    context "when token does not exist" do
      it "returns error" do
        result = described_class.new("wrong_token").verify_email

        expect(result[:success]).to be false
        expect(result[:error]).to eq("Invalid token")
      end
    end

    context "edge case: token sent exactly 2 days ago" do
      let!(:user) do
        create(:user,
          email_verification_token: token,
          email_verification_sent_at: Time.current - 2.days
        )
      end

      it "treats token as valid" do
        result = described_class.new(token).verify_email

        expect(result[:success]).to be true
        expect(result[:user]).to eq(user)
        expect(user.reload.email_verification_sent_at).not_to be_nil
      end
    end
  end
end
