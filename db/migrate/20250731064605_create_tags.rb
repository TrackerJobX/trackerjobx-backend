class CreateTags < ActiveRecord::Migration[8.0]
  def change
    create_table :tags, id: :uuid do |t|
      t.string :name, null: false
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :tags, :name, unique: true, where: "deleted_at IS NULL"
    add_index :tags, :deleted_at
  end
end
