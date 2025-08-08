# frozen_string_literal: true

class InterviewService
  def initialize; end

  def find_all_interviews_by_user(user)
    Interview.joins(:job_application).where(job_applications: { user_id: user.id })
  end

  def find_all_interviews_by_job_application(job_application_id, user)
    job_app = JobApplication.find_by(id: job_application_id, user: user)
  raise ActiveRecord::RecordNotFound, "Job Application not found" unless job_app

    interviews = Interview.joins(:job_application).where(job_applications: { id: job_app.id })
    interviews
  end

  def find_interview(id)
    Interview.find(id)
  end

  def create_interview(params)
    Interview.create!(params)
  end

  def update_interview(id, params)
    interview = find_interview(id)
    interview.update!(params)
    interview
  end

  def destroy_interview(id)
    interview = find_interview(id)
    interview.destroy
  end
end
