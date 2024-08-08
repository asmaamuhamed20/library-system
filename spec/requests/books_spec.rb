require 'rails_helper'

RSpec.describe "Api::V1::Books", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:member) { create(:user, :member) }
  let(:book) { create(:book) }
  let(:valid_attributes) { attributes_for(:book) }
  let(:invalid_attributes) { { title: '', author: '', isbn: '' } }

  let(:valid_headers) { authenticate_user(admin) }
  let(:invalid_headers) { { 'Authorization' => 'Bearer invalidtoken' } }

  describe "GET /index" do
    it "renders a successful response" do
      get api_v1_books_url, headers: valid_headers, as: :json
      expect(response).to be_successful
    end
  end

  describe "GET /show" do
    it "renders a successful response" do
      get api_v1_book_url(book), headers: valid_headers, as: :json
      expect(response).to be_successful
    end

    it "returns a not found response for an invalid book ID" do
      get api_v1_book_url(id: 0), headers: valid_headers, as: :json
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST /create" do
    context "with valid parameters" do
      it "creates a new Book" do
        expect {
          post api_v1_books_url,
               params: { book: valid_attributes }, headers: valid_headers, as: :json
        }.to change(Book, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid parameters" do
      it "does not create a new Book" do
        expect {
          post api_v1_books_url,
               params: { book: invalid_attributes }, headers: valid_headers, as: :json
        }.to change(Book, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH /update" do
    context "with valid parameters" do
      let(:new_attributes) { { title: 'Updated Title' } }

      it "updates the requested book" do
        patch api_v1_book_url(book),
              params: { book: new_attributes }, headers: valid_headers, as: :json
        book.reload
        expect(book.title).to eq('Updated Title')
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid parameters" do
      it "returns an unprocessable entity response" do
        patch api_v1_book_url(book),
              params: { book: invalid_attributes }, headers: valid_headers, as: :json
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE /destroy" do
    it "deletes the requested book" do
      book # create the book
      expect {
        delete api_v1_book_url(book), headers: valid_headers, as: :json
      }.to change(Book, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns a not found response for an invalid book ID" do
      expect {
        delete api_v1_book_url(id: 0), headers: valid_headers, as: :json
      }.to change(Book, :count).by(0)
      expect(response).to have_http_status(:not_found)
    end
  end
end
