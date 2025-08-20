require "rails_helper"

RSpec.describe UserPlanService, type: :service do
  let(:user) { create(:user) }
  let(:plan) { create(:plan, price: 100) }
  let(:service) { described_class.new(user) }

  describe "#find_all_user_plans" do
    it "returns all user plans if user is admin" do
      admin = create(:user, role: "admin")
      create_list(:user_plan, 3, user: admin)
      service = UserPlanService.new(admin)
      expect(service.find_all_user_plans.count).to eq(3)
    end

    it "returns only user plans if user is member" do
      member = create(:user, role: "member")
      create_list(:user_plan, 3, user: member)
      service = UserPlanService.new(member)
      expect(service.find_all_user_plans.count).to eq(3)
    end
  end

  describe "#purchase_plan" do
    let(:plan) { create(:plan, price: 100) }
    let(:user) { create(:user) }
    let(:service) { described_class.new(user) }

    context "when user has no active plan" do
      it "creates a new active user plan" do
        expect {
          service.purchase_plan(plan_id: plan.id, user_id: user.id)
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
        service.purchase_plan(plan_id: plan.id, user_id: user.id)

        expect(active_user_plan.reload.status).to eq("expired")

        new_plan = user.user_plans.order(:created_at).last
        expect(new_plan.plan).to eq(plan)
        expect(new_plan.status).to eq("active")
      end
    end

    context "when create user plan where role is admin" do
      let(:admin) { create(:user, role: "admin") }
      let(:service) { described_class.new(admin) }

      it "creates a new active plan without expiring the old one" do
        old_plan = create(:user_plan, user: admin, status: "active")

        expect {
          service.purchase_plan(plan_id: plan.id, user_id: admin.id, status: "active", purchase_at: Time.current)
        }.to change(UserPlan, :count).by(1)

        expect(old_plan.reload.status).to eq("active") # tetap active
        expect(admin.user_plans.active.count).to eq(2) # jadi ada 2 aktif
      end
    end

    context "when create user plan where role is member" do
      let(:member) { create(:user, role: "member") }
      let(:service) { described_class.new(member) }

      it "expires old plan and creates 1 new active plan" do
        old_plan = create(:user_plan, user: member, status: "active")

        expect {
          service.purchase_plan(plan_id: plan.id, user_id: member.id)
        }.to change(UserPlan, :count).by(1)

        expect(old_plan.reload.status).to eq("expired")
        expect(member.user_plans.active.count).to eq(1)
      end
    end

    context "when plan does not exist" do
      it "raises ActiveRecord::RecordNotFound" do
        expect {
          service.purchase_plan(plan_id: 9999, user_id: user.id)
        }.to raise_error(ActiveRecord::RecordNotFound)
      end
    end
  end
end
