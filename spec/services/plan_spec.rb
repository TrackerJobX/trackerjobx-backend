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
    let(:params) { { name: "Premium", price: 300_000 } }

    it "creates a new plan" do
      expect {
        service.create_plan(params)
      }.to change(Plan, :count).by(1)
    end

    it "raises error if params invalid" do
      expect {
        service.create_plan({ name: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end

  describe "#update_plan" do
    let(:update_params) { { price: 150_000 } }

    it "updates the plan" do
      updated = service.update_plan(plan1.id, update_params)
      expect(updated.price).to eq(150_000)
    end

    it "raises error if plan not found" do
      expect {
        service.update_plan(999, update_params)
      }.to raise_error(ActiveRecord::RecordNotFound)
    end

    it "raises error if params invalid" do
      expect {
        service.update_plan(plan1.id, { name: nil })
      }.to raise_error(ActiveRecord::RecordInvalid)
    end
  end
end
