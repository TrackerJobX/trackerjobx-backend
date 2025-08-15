class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.string :description
      t.integer :price

      t.datetime :deleted_at
      t.timestamps
    end

    add_index :plans, :deleted_at
  end
end
