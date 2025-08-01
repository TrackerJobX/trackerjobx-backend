class CreateJobApplicationTags < ActiveRecord::Migration[8.0]
  def change
    create_table :job_application_tags, id: :uuid do |t|
      t.references :job_application, type: :uuid, null: false, foreign_key: true
      t.references :tag, type: :uuid, null: false, foreign_key: true
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :job_application_tags, :deleted_at
    add_index :job_application_tags, [ :job_application_id, :tag_id ], unique: true
  end
end
