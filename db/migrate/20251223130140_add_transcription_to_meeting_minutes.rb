class AddTranscriptionToMeetingMinutes < ActiveRecord::Migration[8.0]
  def change
    add_column :meeting_minutes, :transcription, :text
    add_column :meeting_minutes, :transcription_status, :integer, default: 0
  end
end
