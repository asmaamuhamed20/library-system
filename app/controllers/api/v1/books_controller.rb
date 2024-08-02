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
    @book = Book.new(book_params)
    if @book.save
      assign_categories(@book, params[:category_ids])
      render json: @book, status: :created, include: :categories
    else
      render json: @book.errors, status: :unprocessable_entity
    end
  end

  def update
    if @book.update(book_params)
      assign_categories(@book, params.dig(:book, :category_ids))
      render json: @book, status: :ok, include: :categories
    else
      render json: @book.errors, status: :unprocessable_entity
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

  def assign_categories(book, category_ids)
    if category_ids.present?
      categories = Category.where(id: category_ids)
      book.categories = categories
      book.save
    end
  end
  
  def authorize_admin
    render_error(:unauthorized, 'Not authorized') unless current_user&.admin?
  end
end
