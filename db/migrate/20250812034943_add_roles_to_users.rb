class AddRolesToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :role, :string, default: "member", null: false
  end
end
