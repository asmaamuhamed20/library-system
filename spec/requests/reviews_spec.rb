require 'rails_helper'

RSpec.describe "Api::V1::Reviews", type: :request do
  let(:user) { create(:user) }
  let(:admin) { create(:user, :admin) }
  let(:book) { create(:book) }
  let!(:review) { create(:review, user: user, book: book) }
  
  let(:valid_attributes) do
    {
      user_id: user.id,
      book_id: book.id,
      rating: 5,
      comment: 'Excellent book!'
    }
  end

  let(:invalid_attributes) do
    {
      user_id: user.id,
      book_id: book.id,
      rating: nil
    }
  end

  describe 'GET /api/v1/reviews' do
    it 'returns a list of reviews' do
      get api_v1_reviews_path, headers: authenticate_user(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(review.comment)
    end
  end

  describe 'GET /api/v1/reviews/:id' do
    it 'returns a review' do
      get api_v1_review_path(review), headers: authenticate_user(user)
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(review.comment)
    end
  end

  describe 'POST /api/v1/reviews' do
    context 'with valid parameters' do
      it 'creates a new Review' do
        expect {
          post api_v1_reviews_path, params: { review: valid_attributes }, headers: authenticate_user(user)
        }.to change(Review, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'with invalid parameters' do
      it 'does not create a new Review' do
        expect {
          post api_v1_reviews_path, params: { review: invalid_attributes }, headers: authenticate_user(user)
        }.not_to change(Review, :count)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH/PUT /api/v1/reviews/:id' do
    context 'with valid parameters' do
      it 'updates the requested review' do
        patch api_v1_review_path(review), params: { review: { rating: 4 } }, headers: authenticate_user(user)
        expect(response).to have_http_status(:ok)
        expect(review.reload.rating).to eq(4)
      end
    end

    context 'with invalid parameters' do
      it 'does not update the review' do
        patch api_v1_review_path(review), params: { review: invalid_attributes }, headers: authenticate_user(user)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/reviews/:id' do
    context 'as an admin' do
      it 'deletes the review' do
        expect {
          delete api_v1_review_path(review), headers: authenticate_user(admin)
        }.to change(Review, :count).by(-1)
        expect(response).to have_http_status(:no_content)
      end
    end

    context 'as a non-admin' do
      it 'does not delete the review' do
        expect {
          delete api_v1_review_path(review), headers: authenticate_user(user)
        }.not_to change(Review, :count)
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
