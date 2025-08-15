# frozen_string_literal: true

class PlanBlueprint < Blueprinter::Base
  identifier :id

  fields :name, :description, :price, :created_at, :updated_at
end
