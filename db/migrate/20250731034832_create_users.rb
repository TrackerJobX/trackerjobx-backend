class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users, id: :uuid do |t|
      t.string :username
      t.string :password_digest
      t.string :email
      t.string :first_name
      t.string :last_name
      t.string :phone
      t.datetime :deleted_at
      t.timestamps
    end

    add_index :users, :email, unique: true, where: "deleted_at IS NULL"
    add_index :users, :deleted_at
  end
end
