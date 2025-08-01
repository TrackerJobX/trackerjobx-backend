class InterviewBlueprint < Blueprinter::Base
  identifier :id

  fields :interview_date, :location, :interview_type, :notes, :job_application_id, :created_at, :updated_at
end
