# frozen_string_literal: true

class PlanService
  def initialize
  end

  def find_all_plan
    Plan.all
  end

  def find_plan(id)
    Plan.find(id)
  end

  def create_plan(params)
    Plan.create!(params)
  end

  def update_plan(id, params)
    plan = Plan.find(id)
    plan.update!(params)
    plan
  end
end
