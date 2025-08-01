# frozen_string_literal: true

class JobApplicationBlueprint < Blueprinter::Base
  identifier :id

  fields :company_name, :position_title, :application_link,  :status, :application_date, :deadline_date, :notes, :created_at, :updated_at

  field :user_id do |job_app|
    job_app.user_id
  end

  association :tags, blueprint: TagBlueprint
  association :attachments, blueprint: AttachmentBlueprint
end
