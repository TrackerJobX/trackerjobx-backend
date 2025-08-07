# frozen_string_literal: true

class Api::V1::JobApplicationsController < Api::V1::BaseController
  def index
    page = (params[:page].to_i > 0) ? params[:page] : 1
    per_page = (params[:per_page].to_i > 0) ? params[:per_page] : 10
    job_apps = service.find_all(current_user.id).page(page).per(per_page)

    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_apps)
    }, status: :ok
  end

  def show
    job_app = service.find_job_application(params[:id])
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :ok
  end

  def create
    job_app = service.create_job_application(job_app_params)
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :created
  rescue ArgumentError => e
      render json: { status: "error", message: e.message }, status: :unprocessable_content
  end

  def update
    job_app = service.update_job_application(params[:id], job_app_params)
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: { status: "error", message: e.message }, status: :unprocessable_content
  rescue ArgumentError => e
    render json: { status: "error", message: e.message }, status: :unprocessable_content
  rescue ActiveRecord::RecordNotFound
      render json: { status: "error", message: "Not Found" }, status: :not_found
  end

  def destroy
    service.destroy_job_application(params[:id])
    render json: { status: "success" }, status: :no_content
  end

  private

  def job_app_params
    params.permit(
      :user_id, :company_name, :position_title,
      :application_link, :status, :application_date,
      :deadline_date, :notes,
      tag_ids: []
    )
  end

  def service
    @service ||= JobApplicationService.new
  end
end
