class AddDetailsToUsers < ActiveRecord::Migration[7.1]
  def change
    add_column :users, :username, :string
    add_column :users, :password_digest, :string
    add_index :users, :username, unique: true
  end
end
