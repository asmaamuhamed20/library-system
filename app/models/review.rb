class Review < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :user_id, :book_id, :rating, presence: true
  validates :rating, inclusion: { in: 1..5 }


  def self.create_with_params(params)
    review = new(params)
    if review.save
      { status: :created, review: review }
    else
      { status: :unprocessable_entity, errors: review.errors }
    end
  end

  def update_with_params(params)
    if update(params)
      { status: :ok, review: self }
    else
      { status: :unprocessable_entity, errors: errors }
    end
  end
end
