class AddForeignKeysToCategorization < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :categorizations, :books, on_delete: :cascade
    add_foreign_key :categorizations, :categories, on_delete: :cascade
  end
end
