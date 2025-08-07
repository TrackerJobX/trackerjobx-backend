# frozen_string_literal: true

class JobApplicationService
  def initialize; end

  def find_all(user_id)
    JobApplication.where(user_id: user_id).order(updated_at: :desc)
  end

  def find_job_application(id)
    JobApplication.find(id)
  end

  def create_job_application(params)
    tags_ids = params.delete(:tags_ids)
    job_app = JobApplication.create!(params)
    job_app.tags  = tags_ids if tags_ids.present?
    job_app
  end

  def update_job_application(id, params, user_id)
    job_app = JobApplication.find(id)
    raise ArgumentError, "Unauthorized" unless job_app.user_id == user_id

    tags_ids = params.delete(:tags_ids)
    job_app.update!(params)
    job_app.tags  = tags_ids if tags_ids.present?
    job_app
  end

  def destroy_job_application(id)
    JobApplication.find(id).destroy!
  end
end
