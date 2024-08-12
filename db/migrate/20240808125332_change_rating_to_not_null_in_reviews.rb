class ChangeRatingToNotNullInReviews < ActiveRecord::Migration[7.1]
  def change
    change_column_null :reviews, :rating, false
  end
end
