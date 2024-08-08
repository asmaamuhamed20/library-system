require 'rails_helper'

RSpec.describe User, type: :model do
  # Validations
  it 'is valid with valid attributes' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user).to be_valid
  end

  it 'is not valid without a username' do
    user = User.new(username: nil, email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate username' do
    User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    user = User.new(username: 'testuser', email: 'newemail@example.com', password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is not valid without an email' do
    user = User.new(username: 'testuser', email: nil, password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is not valid with a duplicate email' do
    User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    user = User.new(username: 'newuser', email: 'test@example.com', password: 'password123')
    expect(user).not_to be_valid
  end

  it 'is not valid with a short password' do
    user = User.new(username: 'testuser', email: 'test@example.com', password: 'short')
    expect(user).not_to be_valid
  end

  it 'can have a role of member' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user.role).to eq('member')
  end

  it 'can change role to admin' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    user.admin!
    expect(user.role).to eq('admin')
  end

  it 'has a secure password' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user.authenticate('password123')).to eq(user)
  end

  it 'does not authenticate with incorrect password' do
    user = User.create(username: 'testuser', email: 'test@example.com', password: 'password123')
    expect(user.authenticate('wrongpassword')).to be_falsey
  end
end
