class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, :book_id, :borrowed_at, :due_date,  presence: true
  validates :returned_at, presence: true, on: :update
  validate :book_available, on: :create

  def self.create_with_params(params)
    borrowing = new(params)
    if borrowing.save
      { status: :created, borrowing: borrowing }
    else
      { status: :unprocessable_entity, errors: borrowing.errors }
    end
  end

  def update_with_params(params)
    if update(params)
      { status: :ok, borrowing: self }
    else
      { status: :unprocessable_entity, errors: errors }
    end
  end

  private

  def book_available
    if Borrowing.where(book_id: book_id, returned_at: nil).exists?
      errors.add(:book_id, 'is already borrowed')
    end
  end
end
