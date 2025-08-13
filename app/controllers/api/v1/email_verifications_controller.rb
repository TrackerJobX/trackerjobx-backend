# frozen_string_literal: true

class Api::V1::EmailVerificationsController < Api::V1::BaseController
  skip_before_action :authorize_request

  def verify
    result = service.verify_email

    if result[:success]
      render json: { status: "success", data: "Email verified successfully" }, status: :ok
    else
      render json: { error: result[:error] }, status: :unprocessable_content
    end
  end

  private

  def service
    service ||= EmailVerificationService.new(params[:token])
  end
end
