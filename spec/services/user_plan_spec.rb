require "rails_helper"

RSpec.describe UserPlanService, type: :service do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, price: 100) }
  let(:service) { described_class.new(user) }

  describe "#purchase_plan" do
    context "when user has no active plan" do
      it "creates a new active user plan" do
        expect {
          service.purchase_plan(plan.id)
        }.to change(UserPlan, :count).by(1)

        user_plan = user.user_plans.last
        expect(user_plan.plan).to eq(plan)
        expect(user_plan.status).to eq("active")
        expect(user_plan.purchase_at).to be_within(1.second).of(Time.current)
      end
    end

    context "when user already has an active plan" do
      let!(:old_plan) { create(:plan, price: 200) }
      let!(:active_user_plan) { create(:user_plan, user: user, plan: old_plan, status: "active") }

      it "expires the old plan and creates a new active plan" do
        service.purchase_plan(plan.id)

        expect(active_user_plan.reload.status).to eq("expired")

        new_plan = user.user_plans.order(:created_at).last
        expect(new_plan.plan).to eq(plan)
        expect(new_plan.status).to eq("active")
      end
    end

    context "when plan does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          service.purchase_plan(9999)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
