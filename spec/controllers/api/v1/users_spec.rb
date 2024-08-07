require 'rails_helper'

RSpec.describe Api::V1::UsersController, type: :controller do
  include AuthHelper

  let(:admin) { create(:user, role: :admin) }
  let(:user) { create(:user) }
  let(:auth_headers) { authenticate_user(admin) }

  before do
    request.headers.merge!(auth_headers)
  end

  describe 'GET #index' do
    before do
      create_list(:user, 3)
      get :index
    end

    it 'returns a list of users' do
      expect(response).to have_http_status(:ok)
      users = JSON.parse(response.body)
      expect(users.size).to eq(4) 
    end
  end

  describe 'GET #show' do
    before do
      get :show, params: { id: user.id }
    end

    it 'returns the user details' do
      expect(response).to have_http_status(:ok)
      returned_user = JSON.parse(response.body)
      expect(returned_user['id']).to eq(user.id)
      expect(returned_user['username']).to eq(user.username)
      expect(returned_user['email']).to eq(user.email)
    end
  end

  describe 'PATCH #update' do
    let(:new_attributes) { { username: 'new_username', email: 'new_email@example.com', role: 'admin' } }

    before do
      patch :update, params: { id: user.id, user: new_attributes }
    end

    it 'updates the user' do
      expect(response).to have_http_status(:ok)
      user.reload
      expect(user.username).to eq('new_username')
      expect(user.email).to eq('new_email@example.com')
      expect(user.role).to eq('admin')
    end
  end

  describe 'DELETE #destroy' do
    before do
      delete :destroy, params: { id: user.id }
    end

    it 'deletes the user' do
      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to be_falsey
    end
  end

  describe 'Authorization' do
    let(:unauthorized_headers) { authenticate_user(user) }

    before do
      request.headers.merge!(unauthorized_headers)
    end

    it 'denies access to non-admin users for index' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for show' do
      get :show, params: { id: user.id }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for update' do
      patch :update, params: { id: user.id, user: { username: 'new_username' } }
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for destroy' do
      delete :destroy, params: { id: user.id }
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
