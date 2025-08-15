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

    if plan.persisted?
      render json: {
        status: "success",
        data: PlanBlueprint.render_as_hash(plan)
      }, status: :created
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: e.record.errors.full_messages
    }, status: :unprocessable_content
  end

  def update
    plan = service.update_plan(params[:id], plan_params)
    render json: {
      status: "success",
      data: PlanBlueprint.render_as_hash(plan)
    }, status: :ok
  rescue ActiveRecord::RecordInvalid => e
    render json: {
      error: e.record.errors.full_messages
    }, status: :unprocessable_content
  end


  private

  def service
    @service ||= PlanService.new
  end

  def plan_params
    params.permit(:name,
                  :description,
                  :price,
                  :job_applications_limit,
                  :interviews_limit,
                  :attachments_limit
    )
  end
end
