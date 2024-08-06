class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, :book_id, :borrowed_at, :due_date, :returned_at, presence: true


  validate :book_available

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
    !Borrowing.where(book_id: book_id).where(returned_at: nil).exists?
  end
end
