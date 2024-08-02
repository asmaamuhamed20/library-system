class AddForeignKeysToCategorizations < ActiveRecord::Migration[7.1]
  def change
    add_foreign_key :categorizations, :books
    add_foreign_key :categorizations, :categories
  end
end
