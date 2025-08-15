class Api::V1::UserPlansController < Api::V1::BaseController
  def index
    render json: {
      status: "success",
      data: UserPlanBlueprint.render_as_hash(current_user.user_plans)
    }
  end

  def create
    service.purchase_plan(params[:plan_id])

    render json: { message: "Plan purchased successfully" }, status: :created
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Plan not found" }, status: :not_found
  rescue StandardError => e
    render json: { error: e.message }, status: :unprocessable_content
  end

  private


  def service
    @service ||= UserPlanService.new(current_user)
  end
end
