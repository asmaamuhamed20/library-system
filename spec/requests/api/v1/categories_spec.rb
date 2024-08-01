require 'rails_helper'

RSpec.describe Api::V1::CategoriesController, type: :controller do
  include AuthHelper

  let!(:admin) { create(:user, :admin) }
  let!(:category) { create(:category) }
  let(:valid_attributes) { { name: 'Science Fiction' } }
  let(:invalid_attributes) { { name: '' } }

  before { authenticate_user(admin) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(category.name)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: category.id }
      expect(response).to have_http_status(:ok)
      expect(response.body).to include(category.name)
    end

    it "returns not found for an invalid category" do
      get :show, params: { id: 'invalid' }
      expect(response).to have_http_status(:not_found)
    end
  end

  describe "POST #create" do
    context "with valid params" do
      it "creates a new category" do
        expect {
          post :create, params: { category: valid_attributes }
        }.to change(Category, :count).by(1)
        expect(response).to have_http_status(:created)
      end
    end

    context "with invalid params" do
      it "does not create a new category" do
        expect {
          post :create, params: { category: invalid_attributes }
        }.to change(Category, :count).by(0)
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      it "updates the requested category" do
        patch :update, params: { id: category.id, category: valid_attributes }
        category.reload
        expect(category.name).to eq('Science Fiction')
        expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        patch :update, params: { id: category.id, category: invalid_attributes }
        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.content_type).to eq("application/json; charset=utf-8")
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested category" do
      expect {
        delete :destroy, params: { id: category.id }
      }.to change(Category, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end

    it "returns not found for an invalid category" do
      expect {
        delete :destroy, params: { id: 'invalid' }
      }.not_to change(Category, :count)
      expect(response).to have_http_status(:not_found)
    end
  end
end
