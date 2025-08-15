class CreateUserPlans < ActiveRecord::Migration[8.0]
  def change
    create_table :user_plans, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.references :plan, type: :uuid, null: false, foreign_key: true
      t.datetime :purchase_at
      t.datetime :expires_at
      t.string :status, default: "not_active"

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :user_plans, :deleted_at
  end
end
