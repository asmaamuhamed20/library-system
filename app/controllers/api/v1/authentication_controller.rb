class Api::V1::AuthenticationController < ApplicationController
  skip_before_action :authenticate_user!, only: [:register, :login]

  # POST /api/v1/register
  def register
    user = User.new(user_params)
    if user.save
      render json: { message: 'User created successfully',  user: user.as_json(only: [:id, :username, :email]) }, status: :created
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

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

  def user_params
    params.permit(:username, :password, :email)
  end
end
