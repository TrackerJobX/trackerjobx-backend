# frozen_string_literal: true

class Api::V1::AttachmentsController < Api::V1::BaseController
  def index
    if params[:job_application_id].present?
      @attachments = service.find_all_by_job_application(params[:job_application_id])
    else
      @attachments = service.find_all_attachments
    end
    render json: {
      status: "success",
      data: AttachmentBlueprint.render_as_hash(@attachments)
    }, status: :ok
  end

  def show
    attachment = service.find_by_id(params[:id])
    render json: {
      status: "success",
      data: AttachmentBlueprint.render_as_hash(attachment)
    }, status: :ok
  end

  def create
    attachment = service.create_attachment(attachment_params)
    render json: {
      status: "success",
      data: AttachmentBlueprint.render_as_hash(attachment)
    }, status: :created
  end

  def destroy
    service.destroy_attachment(params[:id])
    render json: { status: "success" }, status: :no_content
  end

  private

  def service
    @service ||= AttachmentService.new
  end

  def attachment_params
    params.permit(:job_application_id, :attachment_type, :attachment_url, :version)
  end
end
