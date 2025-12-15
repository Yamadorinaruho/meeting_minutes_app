class AddTimeFieldsToMeetingMinutes < ActiveRecord::Migration[8.0]
  def change
    add_column :meeting_minutes, :start_time, :datetime
    add_column :meeting_minutes, :end_time, :datetime
  end
end
