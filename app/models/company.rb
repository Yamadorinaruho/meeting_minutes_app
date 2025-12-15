class Company < ApplicationRecord
  has_many :departments, dependent: :destroy
  has_many :positions, dependent: :destroy
  has_many :employees, dependent: :destroy
  has_many :users, dependent: :destroy
  has_many :meeting_minutes, dependent: :destroy

  validates :name, presence: true
end
