class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :authorize_request
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  attr_reader :current_user

  private

  def authorize_request
    header = request.headers["Authorization"]
    token = header.split(" ").last if header.present?

    begin
      decoded = JwtLib.decode_jwt(token)
      @current_user = User.find(decoded[:user_id])
    rescue ActiveRecord::RecordNotFound, JWT::DecodeError
      render json: { errors: "Unauthorized" }, status: :unauthorized
    end
  end

  def record_not_found(exception)
    render json: {
      status: "error",
      message: "Data not found"
    }, status: :not_found
  end

  def record_invalid(exception)
    render json: {
      status: "error",
      message: exception.message
    }, status: :unprocessable_content
  end
end
