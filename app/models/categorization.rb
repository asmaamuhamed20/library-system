class Categorization < ApplicationRecord
  belongs_to :book
  belongs_to :category

  # Validations
  validates :book_id, presence: true
  validates :category_id, presence: true
end
