require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include AuthHelper

  # Create test data
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let(:valid_attributes) { { username: 'NewName', email: 'newemail@example.com' } }
  let(:invalid_attributes) { { username: '' } }

  before { authenticate_user(admin) }

  describe "GET #index" do
    it "returns a success response" do
      get :index
      expect(response).to have_http_status(:ok)
    end
  end

  describe "GET #show" do
    it "returns a success response" do
      get :show, params: { id: user.id }
       expect(response).to have_http_status(:ok)
    end
  end

  describe "PATCH/PUT #update" do
    context "with valid params" do
      it "updates the requested user" do
        patch :update, params: { id: user.id, user: valid_attributes }
        user.reload
        expect(user.username).to eq('NewName')
      end

      it "renders a JSON response with the user" do
        patch :update, params: { id: user.id, user: valid_attributes }
        expect(response.content_type).to match(a_string_including("application/json"))
         expect(response).to have_http_status(:ok)
      end
    end

    context "with invalid params" do
      it "renders a JSON response with errors" do
        patch :update, params: { id: user.id, user: invalid_attributes }
        expect(response.content_type).to match(a_string_including("application/json"))
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe "DELETE #destroy" do
    it "destroys the requested user" do
      expect {
        delete :destroy, params: { id: user.id }
      }.to change(User, :count).by(-1)
      expect(response).to have_http_status(:no_content)
    end
  end
end
