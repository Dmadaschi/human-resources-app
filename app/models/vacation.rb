class Vacation < ApplicationRecord
  belongs_to :employee

  validates :start_date, :end_date, presence: true
end
