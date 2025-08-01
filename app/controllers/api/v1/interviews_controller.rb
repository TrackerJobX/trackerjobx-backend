# frozen_string_literal: true

class Api::V1::InterviewsController < Api::V1::BaseController
  def index
    interviews = service.find_all_by_job_application(params[:job_application_id])
    render json: {
      status: "success",
      data: InterviewBlueprint.render_as_hash(interviews)
    }, status: :ok
  end

  def show
    interview = service.find_interview(params[:id])
    render json: {
      status: "success",
      data: InterviewBlueprint.render_as_hash(interview)
    }, status: :ok
  end

  def create
    interview = service.create_interview(interview_params)
    render json: {
      status: "success",
      data: InterviewBlueprint.render_as_hash(interview)
    }, status: :created
    rescue ArgumentError => e
      render json: { status: "error", message: e.message }, status: :unprocessable_content
  end

  def update
    interview = service.update_interview(params[:id], interview_params)
    render json: {
      status: "success",
      data: InterviewBlueprint.render_as_hash(interview)
    }, status: :ok
  end

  def destroy
    service.destroy_interview(params[:id])
    render json: { status: "success" }, status: :no_content
  end

  private

  def service
    @service ||= InterviewService.new
  end

  def interview_params
    params.permit(:job_application_id, :interview_date, :location, :interview_type, :notes)
  end
end
