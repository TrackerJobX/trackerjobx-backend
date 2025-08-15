# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PlanService, type: :service do
  let!(:plan1) { Plan.create!(name: "Basic", price: 100_000) }
  let!(:plan2) { Plan.create!(name: "Pro", price: 200_000) }
  let(:service) { described_class.new }

  describe "#find_all_plan" do
    it "returns all plans" do
      result = service.find_all_plan
      expect(result).to match_array([ plan1, plan2 ])
    end
  end

  describe "#find_plan" do
    it "returns the correct plan" do
      result = service.find_plan(plan1.id)
      expect(result).to eq(plan1)
    end

    it "raises ActiveRecord::RecordNotFound if plan does not exist" do
      expect { service.find_plan(999) }.to raise_error(ActiveRecord::RecordNotFound)
    end
  end

  describe "#create_plan" do
    let(:params) { { name: "Premium", price: 300_000, job_applications_limit: 10, interviews_limit: 5, attachments_limit: 20 } }

    it "creates a new plan with limits" do
      created_plan = service.create_plan(params)
      expect(created_plan.job_applications_limit).to eq(10)
      expect(created_plan.interviews_limit).to eq(5)
      expect(created_plan.attachments_limit).to eq(20)
    end

    it "raises error if params invalid" do
      expect {
        service.create_plan({ name: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#update_plan" do
    let(:update_params) { { price: 150_000, job_applications_limit: 50 } }

    it "updates the plan with new limits" do
      updated = service.update_plan(plan1.id, update_params)
      expect(updated.price).to eq(150_000)
      expect(updated.job_applications_limit).to eq(50)
    end

    it "raises error if plan not found" do
      expect {
        service.update_plan(999, update_params)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises error if params invalid" do
      expect {
        service.update_plan(plan1.id, { job_applications_limit: -1 }) # kalau validasi angka >= 0
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
