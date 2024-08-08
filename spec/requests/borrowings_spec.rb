require 'rails_helper'

RSpec.describe "Borrowings API", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:book) { create(:book) }
  
  let(:valid_attributes) do
    {
      user_id: user.id,
      book_id: book.id,
      borrowed_at: Time.current,
      due_date: 1.week.from_now
    }
  end

  let(:invalid_attributes) do
    {
      user_id: user.id,
      book_id: book.id,
      borrowed_at: Time.current,
      due_date: nil
    }
  end

  describe 'POST /api/v1/borrowings' do
    context 'with invalid parameters' do
      before do
        create(:borrowing, user: user, book: book, borrowed_at: Time.current, due_date: 1.week.from_now, returned_at: nil)
      end

      it 'does not create a new Borrowing if the book is already borrowed' do
        post api_v1_borrowings_path, params: { borrowing: valid_attributes }, headers: authenticate_user(user)
        
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.body).to include("is already borrowed")
      end
    end
  end

  describe "PATCH /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing, user: user, book: book, borrowed_at: Time.current, due_date: 1.week.from_now) }

    context "with valid return parameters" do
      it "updates the returned_at date" do
        patch api_v1_borrowing_path(borrowing), params: { borrowing: { returned_at: Time.current } }, headers: authenticate_user(admin)
        
        expect(response).to have_http_status(:ok)
        expect(borrowing.reload.returned_at).not_to be_nil
      end
    end
  end

  describe "DELETE /api/v1/borrowings/:id" do
    let!(:borrowing) { create(:borrowing, user: user, book: book) }

    it "deletes the Borrowing" do
      expect {
        delete api_v1_borrowing_path(borrowing), headers: authenticate_user(admin)
      }.to change(Borrowing, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end