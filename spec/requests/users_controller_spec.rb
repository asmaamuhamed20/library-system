require 'rails_helper'

RSpec.describe 'Api::V1::UsersController', type: :request do
  let(:admin) { create(:user, role: :admin) } 
  let(:user) { create(:user) } 
  let(:auth_headers) { authenticate_user(admin) }

  describe 'GET /api/v1/users' do
    before do
      create_list(:user, 3) 
      get '/api/v1/users', headers: auth_headers
    end

    it 'returns a list of users' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body).size).to eq(4)
    end
  end

  describe 'GET /api/v1/users/:id' do
    before do
      get "/api/v1/users/#{user.id}", headers: auth_headers
    end

    it 'returns the user details' do
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['id']).to eq(user.id)
    end
  end

  describe 'PATCH /api/v1/users/:id' do
    let(:new_attributes) { { username: 'new_username', email: 'new_email@example.com', role: 'admin' } }

    before do
      patch "/api/v1/users/#{user.id}", params: { user: new_attributes }, headers: auth_headers
    end

    it 'updates the user' do
      expect(response).to have_http_status(:ok)
      expect(User.find(user.id).username).to eq('new_username')
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    before do
      delete "/api/v1/users/#{user.id}", headers: auth_headers
    end

    it 'deletes the user' do
      expect(response).to have_http_status(:no_content)
      expect(User.exists?(user.id)).to be_falsey
    end
  end

  describe 'Authorization' do
    let(:unauthorized_headers) { authenticate_user(user) }

    it 'denies access to non-admin users for index' do
      get '/api/v1/users', headers: unauthorized_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for show' do
      get "/api/v1/users/#{user.id}", headers: unauthorized_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for update' do
      patch "/api/v1/users/#{user.id}", params: { user: { username: 'new_username' } }, headers: unauthorized_headers
      expect(response).to have_http_status(:unauthorized)
    end

    it 'denies access to non-admin users for destroy' do
      delete "/api/v1/users/#{user.id}", headers: unauthorized_headers
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
