# frozen_string_literal: true

class JobApplicationService
  def initialize; end

  def find_all(user_id)
    JobApplication.where(user_id: user_id)
  end

  def find_job_application(id)
    JobApplication.find(id)
  end

  def create_job_application(params)
    JobApplication.create!(params)
  end

  def update_job_application(id, params)
    job_app = JobApplication.find(id)
    job_app.update!(params)
    job_app
  end

  def destroy_job_application(id)
    JobApplication.find(id).destroy
  end
end
