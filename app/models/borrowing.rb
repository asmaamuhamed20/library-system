class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :borrowed_on, :due_date, presence: true
end
