class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  rescue_from ActiveRecord::RecordInvalid, with: :record_invalid

  private

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
