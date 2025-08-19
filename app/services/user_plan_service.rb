# frozen_string_literal: true

class UserPlanService
  def initialize(user)
    @user = user
  end

  def find_all_user_plans
    if @user.role == "admin"
      UserPlan.all
    else
      @user.user_plans
    end
  end

  def purchase_plan(plan_id)
    plan = Plan.find(plan_id)

    ActiveRecord::Base.transaction do
      # Expire semua plan aktif sebelumnya
      @user.user_plans.active.update_all(status: "expired")

      # Create new plan
      @user.user_plans.create!(
        plan: plan,
        status: "active",
        purchase_at: Time.current,
      )
    end
  end
end
