# frozen_string_literal: true

class PlanBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :price, :job_applications_limit, :interviews_limit, :attachments_limit, :created_at, :updated_at
end
