class User < ApplicationRecord
  has_secure_password

  enum role: { member: 0, admin: 1 }

  # Validations
  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :password, presence: true, length: { minimum: 6 }
end
