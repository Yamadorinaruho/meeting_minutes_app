class User < ApplicationRecord
  belongs_to :company
  belongs_to :employee

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
