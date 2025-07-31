class CreateJobApplications < ActiveRecord::Migration[8.0]
  def change
    create_table :job_applications, id: :uuid do |t|
      t.references :user, type: :uuid, null: false, foreign_key: true
      t.string :company_name
      t.string :position_title
      t.string :application_link
      t.string :status, default: 'draft'
      t.datetime :application_date
      t.datetime :deadline_date
      t.text :notes
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :job_applications, :deleted_at
  end
end
