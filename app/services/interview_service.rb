# frozen_string_literal: true

class InterviewService
  def initialize; end

  def find_all_by_job_application(job_application_id)
    Interview.where(job_application_id: job_application_id)
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
