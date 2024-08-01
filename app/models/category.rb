class Category < ApplicationRecord


  # Associations
  has_many :categorizations
  has_many :books, through: :categorizations

  validates :name, presence: true
end
