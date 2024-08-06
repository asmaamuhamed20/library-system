require 'rails_helper'

RSpec.describe 'Api::V1::Authentication', type: :request do
  let(:valid_attributes) do
    { username: 'testuser', email: 'testuser@example.com', password: 'password123' }
  end

  let(:invalid_attributes) do
    { username: '', email: 'invalidemail', password: '' }
  end

  describe 'POST /api/v1/register' do
    it 'creates a new user with valid attributes' do
      post '/api/v1/register', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:created)
      expect(JSON.parse(response.body)['message']).to eq('User created successfully')
    end

    it 'returns validation errors with invalid attributes' do
      post '/api/v1/register', params: invalid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:unprocessable_entity)
      expect(JSON.parse(response.body)['errors']).to be_an(Array)
    end
  end

  describe 'POST /api/v1/login' do
    before do
      post '/api/v1/register', params: valid_attributes.to_json, headers: { 'Content-Type': 'application/json' }
    end

    it 'returns a JWT token with valid credentials' do
      post '/api/v1/login', params: { email: 'testuser@example.com', password: 'password123' }.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:ok)
      expect(JSON.parse(response.body)['token']).to be_a(String)
    end

    it 'returns an error with invalid credentials' do
      post '/api/v1/login', params: { email: 'testuser@example.com', password: 'wrongpassword' }.to_json, headers: { 'Content-Type': 'application/json' }
      expect(response).to have_http_status(:unauthorized)
      expect(JSON.parse(response.body)['error']).to eq('Invalid credentials')
    end
  end
end
