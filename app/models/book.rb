class Book < ApplicationRecord

  # Validations
  validates :title, :author, :isbn, :description, presence: true
  validates :isbn, uniqueness: true
  validates :published_date, presence: true

  # Associations
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations

  def self.create_with_categories(book_params, category_ids)
    book = new(book_params)
    if book.save
      CategoryAssignmentService.new(book, category_ids).assign
    end
    book
  end

  def update_with_categories(book_params, category_ids)
    if update(book_params)
      CategoryAssignmentService.new(self, category_ids).assign
      { status: :ok, book: self }
    else
      { status: :unprocessable_entity, errors: errors.full_messages }
    end
  end
end
