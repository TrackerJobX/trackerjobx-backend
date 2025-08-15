# frozen_string_literal: true

class UserPlanService
  def initialize(user)
    @user = user
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
        purchased_at: Time.current,
        expires_at: Time.current + plan.duration_days.days
      )
    end
  end
end
