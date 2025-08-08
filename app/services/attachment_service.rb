# frozen_string_literal: true

class AttachmentService
  def initialize; end

  def find_all_attachments_by_user(user)
    Attachment.joins(:job_application).where(job_applications: { user_id: user.id })
  end

  def find_all_attachments_by_job_application(job_application_id, user)
    job_app = JobApplication.find_by(id: job_application_id, user: user)
  raise ActiveRecord::RecordNotFound, "Job Application not found" unless job_app

  job_app.attachments
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
