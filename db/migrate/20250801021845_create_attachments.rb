class CreateAttachments < ActiveRecord::Migration[8.0]
  def change
    create_table :attachments, id: :uuid do |t|
      t.references :job_application, type: :uuid, null: false, foreign_key: true
      t.string :attachment_type, null: false
      t.string :attachment_url, null: false
      t.string :version
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :attachments, :deleted_at
  end
end
