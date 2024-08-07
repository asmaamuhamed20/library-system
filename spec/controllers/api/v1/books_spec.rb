require 'rails_helper'

RSpec.describe Api::V1::BooksController, type: :controller do
  include AuthHelper

  let(:admin_user) { create(:user, :admin) }
  let(:regular_user) { create(:user) }
  let(:book) { create(:book) }
  let(:valid_attributes) { attributes_for(:book) }
  let(:invalid_attributes) { { title: '' } }

  before do
    request.headers.merge!(authenticate_user(admin_user))
  end

  describe 'GET #index' do
    it 'returns a success response' do
      get :index
      expect(response).to be_successful
    end
  end

  describe 'GET #show' do
    it 'returns a success response' do
      get :show, params: { id: book.to_param }
      expect(response).to be_successful
    end
  end

  describe 'POST #create' do
    context 'with valid parameters' do
      it 'creates a new Book' do
        expect {
          post :create, params: { book: valid_attributes }
        }.to change(Book, :count).by(1)
      end

      it 'renders a JSON response with the new book' do
        post :create, params: { book: valid_attributes }
        expect(response).to have_http_status(:created)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/#{Book.last.title}/)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the new book' do
        post :create, params: { book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  describe 'PATCH #update' do
    context 'with valid parameters' do
      let(:new_attributes) { { title: 'Updated Title' } }

      it 'updates the requested book' do
        patch :update, params: { id: book.to_param, book: new_attributes }
        book.reload
        expect(book.title).to eq('Updated Title')
      end

      it 'renders a JSON response with the book' do
        patch :update, params: { id: book.to_param, book: new_attributes }
        expect(response).to have_http_status(:ok)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/Updated Title/)
      end
    end

    context 'with invalid parameters' do
      it 'renders a JSON response with errors for the book' do
        patch :update, params: { id: book.to_param, book: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq('application/json; charset=utf-8')
        expect(response.body).to match(/can't be blank/)
      end
    end
  end

  describe 'DELETE #destroy' do
    it 'destroys the requested book' do
      book_to_delete = create(:book)
      expect {
        delete :destroy, params: { id: book_to_delete.to_param }
      }.to change(Book, :count).by(-1)
    end

    it 'renders a JSON response with no content' do
      delete :destroy, params: { id: book.to_param }
      expect(response).to have_http_status(:no_content)
    end
  end
end
