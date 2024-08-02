class Categorization < ApplicationRecord
  belongs_to :book
  belongs_to :category

  # Validations
  validates :book, presence: true
  validates :category, presence: true
end
