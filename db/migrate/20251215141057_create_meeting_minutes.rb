class CreateMeetingMinutes < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_minutes do |t|
      t.references :company, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.string :title
      t.datetime :meeting_date
      t.text :content

      t.timestamps
    end
  end
end
