# frozen_string_literal: true

class AttachmentService
  def initialize; end

  def find_all_by_job_application(job_application_id)
    Attachment.where(job_application_id: job_application_id)
  end

  def find_by_id(id)
    Attachment.find(id)
  end

  def create_attachment(params)
    Attachment.create!(params)
  end

  def destroy_attachment(id)
    attachment = Attachment.find(id)
    attachment.destroy!
  end
end
