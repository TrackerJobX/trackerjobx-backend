require "rails_helper"

RSpec.describe Api::V1::EmailVerificationsController, type: :controller do
  describe "GET #verify" do
    let(:token) { "validtoken123" }
    let(:service_instance) { instance_double(EmailVerificationService) }

    before do
      allow(EmailVerificationService).to receive(:new).with(token).and_return(service_instance)
    end

    context "when token is valid" do
      before do
        allow(service_instance).to receive(:verify_email).and_return({ success: true })
      end

      it "returns success response" do
        get :verify, params: { token: token }

        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({
          "status" => "success",
          "data"   => "Email verified successfully"
        })
      end
    end

    context "when token is expired" do
      before do
        allow(service_instance).to receive(:verify_email).and_return({ success: false, error: "Token expired" })
      end

      it "returns error response" do
        get :verify, params: { token: token }

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq({ "error" => "Token expired" })
      end
    end

    context "when token is invalid" do
      before do
        allow(service_instance).to receive(:verify_email).and_return({ success: false, error: "Invalid token" })
      end

      it "returns error response" do
        get :verify, params: { token: token }

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq({ "error" => "Invalid token" })
      end
    end

    context "when token is missing" do
      let(:token) { nil }

      before do
        allow(EmailVerificationService).to receive(:new).with(nil).and_return(service_instance)
        allow(service_instance).to receive(:verify_email).and_return({ success: false, error: "Token missing" })
      end

      it "returns error response" do
        get :verify, params: {}

        expect(response).to have_http_status(:unprocessable_content)
        expect(JSON.parse(response.body)).to eq({ "error" => "Token missing" })
      end
    end
  end
end
