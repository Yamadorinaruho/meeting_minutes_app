class CreateMeetingMinuteShares < ActiveRecord::Migration[8.0]
  def change
    create_table :meeting_minute_shares do |t|
      t.references :meeting_minute, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true

      t.timestamps
    end
  end
end
