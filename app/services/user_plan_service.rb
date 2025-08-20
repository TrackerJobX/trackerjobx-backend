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

  def purchase_plan(params)
    plan = Plan.find(params[:plan_id])
    user = User.find(params[:user_id])

    ActiveRecord::Base.transaction do
      # Expire semua plan aktif sebelumnya
      if user.role == "admin"
        UserPlan.create(plan: plan, user: user, status: params[:status], purchase_at: params[:purchase_at])
      else
        @user.user_plans.active.update_all(status: "expired")
        @user.user_plans.create!(plan: plan, status: "active", purchase_at: Time.current)
      end
    end
  end
end
