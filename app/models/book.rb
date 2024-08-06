class Book < ApplicationRecord

  # Validations
  validates :title, :author, :isbn, :description, presence: true
  validates :isbn, uniqueness: true
  validates :published_date, presence: true

  # Associations
  has_many :categorizations, dependent: :destroy
  has_many :categories, through: :categorizations
  has_many :borrowings
end
