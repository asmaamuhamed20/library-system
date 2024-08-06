class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]
  before_action :authorize_admin, only: %i[create update destroy]

  # Retrieves a list of all books.
  #
  # @return [Array<Book>] The list of books.
  # @example Request
  # GET /api/v1/books
  def index
    @books = Book.includes(:categories).all
    render json: @books, include: :categories
  end

  # Retrieves a specific book by its ID.
  #
  # @param id [Integer] The ID of the book to retrieve.
  # @return [Book] The requested book.
  # @example Request
  # GET /api/v1/books/{id}
  def show
    render json: @book, include: :categories
  end

  # Creates a new book.
  #
  # @param book_params [Hash] The parameters for creating a new book.
  # @option book_params [String] :title The title of the book.
  # @option book_params [String] :author The author of the book.
  # @option book_params [String] :isbn The ISBN of the book.
  # @option book_params [String] :description A description of the book.
  # @option book_params [Date] :published_date The published date of the book.
  # @return [Book] The created book.
  # @example Request
  #   POST /api/v1/books
  #   Request Body: { "book": { "title": "New Book", "author": "Author Name", "isbn": "1234567890", "description": "Book Description", "published_date": "2024-08-01", "categories": [{ "id": 2, "name": "Updated Category" } } }
  # @example Response
  #   HTTP Status: 201 Created
  def create
    @book = Book.create_with_categories(book_params, params[:categories])
    if @book.persisted?
      render json: @book, status: :created, include: :categories
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  # Updates an existing book.
  #
  # @param id [Integer] The ID of the book to update.
  # @param book_params [Hash] The parameters for updating the book.
  # @option book_params [String] :title The new title of the book.
  # @option book_params [String] :author The new author of the book.
  # @option book_params [String] :isbn The new ISBN of the book.
  # @option book_params [String] :description The new description of the book.
  # @option book_params [Date] :published_date The new published date of the book.
  # @return [Book] The updated book.
  # @example Request
  #   PATCH /api/v1/books/1
  #   Request Body: { "book": { "title": "Updated Book", "author": "Updated Author", "isbn": "0987654321", "description": "Updated Description", "published_date": "2024-08-02",  "categories": [{ "id": 2, "name": "Updated Category" } } }
  # @example Response
  #   HTTP Status: 200 OK
  def update
    result = @book.update_with_categories(book_params, params[:book][:category_ids])
    if result[:status] == :ok
      render json: result[:book], status: :ok, include: :categories
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  # Deletes a specific book by its ID.
  #
  # @param id [Integer] The ID of the book to delete.
  # @return [Head] No content.
  # @example Request
  #   DELETE /api/v1/books/1
  # @example Response
  #   HTTP Status: 204 No Content
  def destroy
    if @book.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete book' }, status: :unprocessable_entity
    end
  end

  private

  # Sets the book instance variable based on the ID provided in the params.
  #
  # @raise [ActiveRecord::RecordNotFound] If the book is not found.
  # @return [Book] The book with the given ID
  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  # Permits the parameters for creating/updating a book.
  #
  # @return [ActionController::Parameters] The permitted parameters.
  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :published_date, category_ids: [])
  end


  
  # Authorizes that the current user is an admin.
  #
  # @raise [StandardError] If the user is not authorized.
  def authorize_admin
    render_error(:unauthorized, 'Not authorized') unless current_user&.admin?
  end
end
