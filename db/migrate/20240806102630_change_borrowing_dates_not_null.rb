class ChangeBorrowingDatesNotNull < ActiveRecord::Migration[7.1]
  def change
    change_column_null :borrowings, :borrowed_at, false
    change_column_null :borrowings, :due_date, false
  end
end
