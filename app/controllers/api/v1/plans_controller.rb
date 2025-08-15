# frozen_string_literal: true

class Api::V1::PlansController < Api::V1::BaseController
  def index
    plans = service.find_all_plan
    render json: {
      status: "success",
      data: PlanBlueprint.render_as_hash(plans)
    }, status: :ok
  end

  def show
    plan = service.find_plan(params[:id])
    render json: {
      status: "success",
      data: PlanBlueprint.render_as_hash(plan)
    }, status: :ok
  end

  def create
    plan = service.create_plan(plan_params)
    render json: {
      status: "success",
      data: PlanBlueprint.render_as_hash(plan)
    }, status: :created
  end

  private

  def service
    @service ||= PlanService.new
  end

  def plan_params
    params.permit(:name, :price)
  end
end
