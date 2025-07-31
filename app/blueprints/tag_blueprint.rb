# frozen_string_literal: true

class TagBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :created_at, :updated_at
end
