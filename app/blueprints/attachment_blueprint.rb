class AttachmentBlueprint < Blueprinter::Base
  identifier :id

  fields :attachment_type, :attachment_url, :version, :created_at
end
