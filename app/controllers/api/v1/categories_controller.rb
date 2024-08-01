class Api::V1::CategoriesController < ApplicationController
  before_action :set_category, only: [:show, :update, :destroy]
  before_action :authorize_admin, only: %i[index create update destroy show]

   # Retrieves a list of all categories.
  #
  # @return [Array<Category>] The list of categories.
  # @example Request
  # GET /api/v1/categories
  def index
    @categories = Category.all
    render json: @categories
  end

  # Retrieves a specific category by its ID.
  #
  # @param id [Integer] The ID of the category to retrieve.
  # @return [Category] The requested category.
  # @example Request
  # GET /api/v1/categories/{id}
  def show
    render json: @category
  end

 # Creates a new category.
  #
  # @param category_params [Hash] The parameters for creating a new category.
  # @option category_params [String] :name The name of the category.
  # @return [Category] The created category.
  # @example Request
  #   POST /api/v1/categories/create
  #   Request Body: { "category": { "name": "New Category" } }
  # @example Response
  #   HTTP Status: 201 Created
  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # Updates an existing category.
  #
  # @param id [Integer] The ID of the category to update.
  # @param category_params [Hash] The parameters for updating the category.
  # @option category_params [String] :name The new name of the category.
  # @return [Category] The updated category.
  # @example Request
  #   PATCH /api/v1/categories/1
  #   Request Body: { "category": { "name": "Updated Category" } }
  # @example Response
  #   HTTP Status: 200 OK
  def update
    if @category.update(category_params)
      render json: @category, status: :ok
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  # Deletes a specific category by its ID.
  #
  # @param id [Integer] The ID of the category to delete.
  # @return [Head] No content.
  # @example Request
  #   DELETE /api/v1/categories/1
  # @example Response
  #   HTTP Status: 204 No Content
  def destroy
    if @category
      @category.destroy
      head :no_content
    else
      render json: { error: 'Category not found' }, status: :not_found
    end
  end

  private

  # Sets the category instance variable based on the ID provided in the params.
  #
  # @raise [ActiveRecord::RecordNotFound] If the category is not found.
  # @return [Category] The category with the given ID
  def set_category
    @category = Category.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Category not found' }, status: :not_found
  end

  # Permits the parameters for creating/updating a category.
  #
  # @return [ActionController::Parameters] The permitted parameters.
  def category_params
    params.require(:category).permit(:name)
  end

  # Authorizes that the current user is an admin.
  #
  # @raise [StandardError] If the user is not authorized.
  def authorize_admin
    render_error(:unauthorized, 'Not authorized') unless current_user.admin?
  end
end
