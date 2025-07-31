# frozen_string_literal: true

class JobApplicationService
  def initialize; end

  def find_all(user_id)
    JobApplication.where(user_id: user_id)
  end

  def find(id)
    JobApplication.find(id)
  end

  def create(params)
    JobApplication.create!(params)
  end

  def update(id, params)
    job_app = JobApplication.find(id)
    job_app.update!(params)
    job_app
  end

  def destroy(id)
    JobApplication.find(id).destroy
  end
end
