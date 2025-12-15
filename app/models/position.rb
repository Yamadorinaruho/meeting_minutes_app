class Position < ApplicationRecord
  belongs_to :company
  has_many :employees, dependent: :nullify

  validates :name, presence: true
  validates :hourly_rate, presence: true, numericality: { greater_than: 0 }

  default_scope { order(:rank) }
end
