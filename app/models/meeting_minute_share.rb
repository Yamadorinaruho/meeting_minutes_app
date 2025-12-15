class MeetingMinuteShare < ApplicationRecord
  belongs_to :meeting_minute
  belongs_to :employee

  validates :employee_id, uniqueness: { scope: :meeting_minute_id }
end
