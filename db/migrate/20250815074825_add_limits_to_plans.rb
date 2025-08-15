class AddLimitsToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :job_applications_limit, :integer, default: 0
    add_column :plans, :interviews_limit, :integer, default: 0
    add_column :plans, :attachments_limit, :integer, default: 0
  end
end
