class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: %i[show update destroy]
  before_action :authorize_admin, only: %i[create update destroy]

  def index
    @books = Book.includes(:categories).all
    render json: @books, include: :categories
  end

  def show
    render json: @book, include: :categories
  end

  def create
    @book = Book.create_with_categories(book_params, params[:categories])
    if @book.persisted?
      render json: @book, status: :created, include: :categories
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    result = @book.update_with_categories(book_params, params[:book][:category_ids])
    if result[:status] == :ok
      render json: result[:book], status: :ok, include: :categories
    else
      render json: { errors: result[:errors] }, status: result[:status]
    end
  end

  def destroy
    if @book.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete book' }, status: :unprocessable_entity
    end
  end

  private

  def set_book
    @book = Book.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Book not found' }, status: :not_found
  end

  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :published_date, category_ids: [])
  end

  
  def authorize_admin
    render_error(:unauthorized, 'Not authorized') unless current_user&.admin?
  end
end
