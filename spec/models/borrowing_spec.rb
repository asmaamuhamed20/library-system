require 'rails_helper'

RSpec.describe Borrowing, type: :model do
  let(:user) { create(:user) }
  let(:book) { create(:book) }

  describe '.create_with_params' do
    let(:valid_attributes) do
      {
        user_id: user.id,
        book_id: book.id,
        borrowed_at: Time.current,
        due_date: 1.week.from_now,
        returned_at: Time.current 
      }
    end

    it 'creates a new Borrowing and returns success status' do
      result = Borrowing.create_with_params(valid_attributes)
      expect(result[:status]).to eq(:created)
      expect(result[:borrowing]).to be_persisted
    end
  
    it 'does not create a new Borrowing with invalid parameters' do
      result = Borrowing.create_with_params({ user_id: nil, book_id: book.id, borrowed_at: nil, due_date: nil, returned_at: Time.current })
      expect(result[:status]).to eq(:unprocessable_entity)
      expect(result[:errors].full_messages).to include("User can't be blank", "Borrowed at can't be blank", "Due date can't be blank")
    end
  end

  describe '#update_with_params' do
    let(:borrowing) do
      create(:borrowing, user: user, book: book, borrowed_at: 1.day.ago, due_date: 1.week.from_now, returned_at: Time.current)
    end

    let(:valid_update_attributes) { { returned_at: 1.day.ago } }

    it 'updates the Borrowing and returns success status' do
      result = borrowing.update_with_params(valid_update_attributes)
      expect(result[:status]).to eq(:ok)
      expect(borrowing.reload.returned_at).to be_within(1.second).of(1.day.ago)
    end
  end

  describe '#book_available' do
    let!(:borrowed_book) do
      create(:borrowing, user: user, book: book, borrowed_at: 1.day.ago, due_date: 1.week.from_now, returned_at: nil)
    end

    it 'returns false if the book is already borrowed' do
      new_borrowing = build(:borrowing, user: user, book: book, borrowed_at: Time.current, due_date: 1.week.from_now, returned_at: 1.week.from_now)
      expect(new_borrowing).not_to be_valid
      expect(new_borrowing.errors[:book_id]).to include("is already borrowed")
    end
  end
end
