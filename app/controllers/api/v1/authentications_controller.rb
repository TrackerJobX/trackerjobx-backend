# frozen_string_literal: true

class Api::V1::AuthenticationsController < Api::V1::BaseController
  def signup
    result = service.signup_user(user_params)
    render json: result[:json], status: result[:status]
  end

  def signin
    result = service.signin_user(params[:email], params[:password])
    render json: result[:json], status: result[:status]
  end

  def forgot_password
    result = service.forgot_password_user(params[:email])
    render json: result[:json], status: result[:status]
  end

  private

  def service
    @service ||= AuthenticationService.new
  end

  def user_params
    params.permit(:email, :first_name, :last_name, :password, :password_confirmation)
  end
end
