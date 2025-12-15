class Department < ApplicationRecord
  belongs_to :company
  has_many :employees, dependent: :nullify

  validates :name, presence: true
end
