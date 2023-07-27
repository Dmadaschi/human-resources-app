class Employee < ApplicationRecord
  has_many :vacations

  validates :name, :role, :hiring_date, presence: true
end
