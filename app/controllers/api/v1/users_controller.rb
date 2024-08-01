class Api::V1::UsersController < ApplicationController
  before_action :set_user, only: %i[show update destroy]
  before_action :authorize_admin, only: %i[index update destroy show]

  # Retrieves a list of all users.
  #
  # @return [Array<User>] The list of users.
  # @example Request
  # GET /users
  def index
    @users = User.all
    render json: @users
  end

  # Retrieves a specific user by their ID.
  #
  # @param id [Integer] The ID of the user to retrieve.
  # @return [User] The requested user.
  # @example Request
  # GET /users/:id
  def show
    render json: @user
  end

  # Updates an existing user.
  #
  # @param id [Integer] The ID of the user to update.
  # @param user_update_params [Hash] The parameters for updating the user.
  # @option user_update_params [String] :username The new username of the user.
  # @option user_update_params [String] :email The new email of the user.
  # @option user_update_params [String] :role The new role of the user.
  # @return [User] The updated user.
  # @example Request
  #   PATCH /users/1
  #   Request Body: { "user": { "username": "new_username", "email": "new_email@example.com", "role": "admin" } }
  # @example Response
  #   HTTP Status: 200 OK
  def update
    if @user.update(user_update_params)
      render json: @user
    else
      render json: @user.errors, status: :unprocessable_entity
    end
  end

  # Deletes a specific user by their ID.
  #
  # @param id [Integer] The ID of the user to delete.
  # @return [Head] No content.
  # @example Request
  #   DELETE /users/1
  # @example Response
  #   HTTP Status: 204 No Content
  def destroy
    @user.destroy
    head :no_content
  end

  private


  # Sets the user instance variable based on the ID provided in the params.
  #
  # @return [User] The user with the given ID.
  def set_user
    @user = User.find(params[:id])
  end

  # Permits the parameters for updating a user.
  #
  # @return [ActionController::Parameters] The permitted parameters.
  def user_update_params
    params.require(:user).permit(:username, :email, :role)
  end

  # Authorizes that the current user is an admin.
  #
  # @raise [StandardError] If the user is not authorized.
  def authorize_admin
    render_unauthorized unless current_user&.admin?
  end
end
