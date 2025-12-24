# frozen_string_literal: true

class TranscriptionJob < ApplicationJob
  queue_as :default

  retry_on TranscriptionService::Error, wait: 5.seconds, attempts: 3

  def perform(meeting_minute_id)
    meeting_minute = MeetingMinute.find(meeting_minute_id)

    return unless meeting_minute.audio.attached?
    return if meeting_minute.transcription.present?

    TranscriptionService.new(meeting_minute).call
  end
end
