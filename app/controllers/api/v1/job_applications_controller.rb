# frozen_string_literal: true

class Api::V1::JobApplicationsController < Api::V1::BaseController
  def index
    job_apps = service.find_all(params[:user_id])
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_apps)
    }, status: :ok
  end

  def show
    job_app = service.find(params[:id])
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :ok
  end

  def create
    job_app = service.create(job_app_params)
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :created
  end

  def update
    job_app = service.update(params[:id], job_app_params)
    render json: {
      status: "success",
      data: JobApplicationBlueprint.render_as_hash(job_app)
    }, status: :ok
  end

  def destroy
    service.destroy(params[:id])
    render json: { status: "success" }, status: :no_content
  end

  private

  def job_app_params
    params.permit(:user_id, :company_name, :position_title, :application_link, :status, :application_date, :deadline_date, :notes)
  end

  def service
    @service ||= JobApplicationService.new
  end
end
