# frozen_string_literal: true

class UserPlanBlueprint < Blueprinter::Base
  identifier :id

  fields :user_id, :plan_id, :status, :purchase_at, :expires_at, :created_at, :updated_at
end
