class Api::V1::UserPlansController < Api::V1::BaseController
  def index
    render json: {
      status: "success",
      data: UserPlanBlueprint.render_as_hash(service.find_all_user_plans)
    }
  end

  def create
    service.purchase_plan(user_plan_params)

    render json: { message: "Plan purchased successfully" }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Plan not found" }, status: :not_found
  end

  private


  def service
    @service ||= UserPlanService.new(current_user)
  end

  def user_plan_params
    params.permit(:plan_id, :user_id, :status, :purchase_at)
  end
end
