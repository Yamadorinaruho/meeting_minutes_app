class Employee < ApplicationRecord
  belongs_to :company
  belongs_to :department, optional: true
  belongs_to :position, optional: true
  has_one :user, dependent: :destroy
  has_many :meeting_minutes, dependent: :restrict_with_error
  has_many :meeting_minute_shares, dependent: :destroy
  has_many :shared_meeting_minutes, through: :meeting_minute_shares, source: :meeting_minute

  enum :status, { active: 0, retired: 1 }

  validates :name, presence: true
  validates :employee_number, presence: true
  validates :email, presence: true

  def admin?
    admin
  end

  def hourly_rate
    position&.hourly_rate || 0
  end
end
