# frozen_string_literal: true

class UserBlueprint < Blueprinter::Base
  identifier :id

  fields :username, :email, :first_name, :last_name, :phone, :role, :created_at, :updated_at

  field :plan_name do |user, _options|
    user.user_plans.last&.plan&.name
  end
end
