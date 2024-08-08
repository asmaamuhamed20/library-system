require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  include AuthHelper

  let!(:admin) { create(:user, :admin) }
  let!(:book) { create(:book) }
  let(:auth_headers) { authenticate_user(admin) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe 'GET /books' do
    it 'returns a success response' do
      get :index
      expect(response).to have_http_status(:success)
    end
  end

  describe 'GET /books/:id' do
    context 'when the book exists' do
      it 'returns a success response' do
        get :show, params: { id: book.id }
        expect(response).to have_http_status(:success)
      end
    end

    context 'when the book does not exist' do
      it 'returns a not found response' do
        get :show, params: { id: 999 }
        expect(response).to have_http_status(:not_found)
      end
    end
  end

  describe 'POST /books' do
    context 'when the request is valid' do
      let(:valid_attributes) { attributes_for(:book) }

      it 'creates a new book' do
        post :create, params: { book: valid_attributes }
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { title: nil } }

      it 'returns an unprocessable entity response' do
        post :create, params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /books/:id' do
    context 'when the record exists' do
      let(:valid_attributes) { { title: 'Updated Title' } }

      it 'updates the record' do
        put :update, params: { id: book.id, book: valid_attributes }
        book.reload
        expect(book.title).to eq('Updated Title')
        expect(response).to have_http_status(:ok)
      end
    end

    context 'when the request is invalid' do
      let(:invalid_attributes) { { title: nil } }

      it 'returns an unprocessable entity response' do
        put :update, params: { id: book.id, book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /books/:id' do
    it 'returns a no content response' do
      expect {
        delete :destroy, params: { id: book.id }
      }.to change(Book, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
