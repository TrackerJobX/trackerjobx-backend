class CreateInterviews < ActiveRecord::Migration[8.0]
  def change
    create_table :interviews, id: :uuid do |t|
      t.references :job_application, type: :uuid, null: false, foreign_key: true
      t.datetime :interview_date
      t.string :location
      t.string :interview_type, default: "online"
      t.text :notes
      t.datetime :deleted_at

      t.timestamps
    end

    add_index :interviews, :deleted_at
  end
end
