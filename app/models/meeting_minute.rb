class MeetingMinute < ApplicationRecord
  belongs_to :company
  belongs_to :employee
  has_many :meeting_minute_shares, dependent: :destroy
  has_many :shared_employees, through: :meeting_minute_shares, source: :employee

  has_one_attached :audio

  enum :transcription_status, { pending: 0, processing: 1, completed: 2, failed: 3 }

  validates :title, presence: true
  validate :acceptable_audio
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  def accessible_by?(employee)
    self.employee_id == employee.id || shared_employees.include?(employee)
  end

  # 会議時間（分）
  def duration_minutes
    return 0 unless start_time && end_time
    ((end_time - start_time) / 60).to_i
  end

  # 会議時間（時間）
  def duration_hours
    duration_minutes / 60.0
  end

  # 参加者全員（作成者 + 共有先）
  def all_participants
    [employee] + shared_employees.to_a
  end

  # 概算コスト（全参加者の時給 × 会議時間）
  def estimated_cost
    hours = duration_hours
    all_participants.sum { |p| p.hourly_rate * hours }
  end

  # meeting_date を start_time から算出（互換性のため）
  def meeting_date
    start_time
  end

  private

  def end_time_after_start_time
    return unless start_time && end_time
    if end_time <= start_time
      errors.add(:end_time, "は開始時刻より後にしてください")
    end
  end

  def acceptable_audio
    return unless audio.attached?

    acceptable_types = ["audio/mpeg", "audio/mp3", "audio/wav", "audio/x-wav", "audio/mp4", "audio/x-m4a", "audio/webm"]
    unless acceptable_types.include?(audio.content_type)
      errors.add(:audio, "はMP3、WAV、M4A、WebM形式のみアップロード可能です")
    end

    if audio.byte_size > 100.megabytes
      errors.add(:audio, "は100MB以下にしてください")
    end
  end
end
