class Book < ApplicationRecord

  # Validations
  validates :title, :author, :isbn, presence: true
  validates :isbn, uniqueness: true

  def self.create_with_params(params)
    book = new(params)
    book.save
    book
  end

  def update_with_params(params)
    update(params)
  end
end
