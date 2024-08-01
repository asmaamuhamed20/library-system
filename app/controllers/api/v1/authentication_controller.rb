class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]

  # Registers a new user.
  #
  # @param username [String] The username for the new user.
  # @param password [String] The password for the new user.
  # @param email [String] The email address for the new user.
  # @return [Hash] A message confirming the creation of the user and the user details.
  # @example Request
  #   POST /api/v1/register
  #   Request Body: { "username": "new_user", "password": "password123", "email": "new_user@example.com" }
  # @example Response
  #   HTTP Status: 201 Created
  #   Response Body: { "message": "User created successfully", "user": { "id": 1, "username": "new_user", "email": "new_user@example.com" } }
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully',  user: user.as_json(only: [:id, :username, :email]) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end


  # Logs in a user and returns a JWT token.
  #
  # @param email [String] The email address of the user attempting to log in.
  # @param password [String] The password of the user attempting to log in.
  # @return [Hash] A JWT token and user details if credentials are valid.
  # @example Request
  #   POST /api/v1/login
  #   Request Body: { "email": "user@example.com", "password": "password123" }
  # @example Response
  #   HTTP Status: 200 OK
  #   Response Body: { "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIiwibmFtZSI6IkpvaG4gRG9lIiwiaWF0IjoxNTE2MjM5MDIyfQ.SflKpP7i4A7dSEkFZ5X1htO2AaRJxJmP-3JrkW_F3_E", "user": { "id": 1, "username": "user", "email": "user@example.com" } }
  # @example Response (Invalid credentials)
  #   HTTP Status: 401 Unauthorized
  #   Response Body: { "error": "Invalid credentials" }
  # POST /api/v1/login
  def login
    user = User.find_by(email: params[:email])
    if user&.authenticate(params[:password])
      token = JsonWebToken.encode(user_id: user.id)
      render json: { token: token, user: user.as_json(only: [:id, :username, :email]) }, status: :ok
    else
      render json: { error: 'Invalid credentials' }, status: :unauthorized
    end
  end

  private

  # Permits the parameters for creating a new user.
  #
  # @return [ActionController::Parameters] The permitted parameters.
  def user_params
    params.permit(:username, :password, :email)
  end
end
