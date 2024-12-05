class Api::V1::BorrowingsController < ApplicationController
  before_action :set_borrowing, only: [:update, :destroy]
  before_action :authorize_member, only: [:create]
  before_action :authorize_admin, only: [:update, :destroy]

  def create
    result = Borrowing.create_with_params(borrowing_params)
    if result[:status] == :created
      render json: result[:borrowing], status: :created
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  def update
    result = @borrowing.update_with_params(borrowing_params)
    if result[:status] == :ok
      render json: result[:borrowing], status: :ok
    else
      render json: result[:errors], status: :unprocessable_entity
    end
  end

  def destroy
    if @borrowing.destroy
      head :no_content
    else
      render json: { error: 'Failed to delete borrowing record' }, status: :unprocessable_entity
    end
  end

  private

  def set_borrowing
    @borrowing = Borrowing.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: 'Borrowing record not found' }, status: :not_found
  end

  def borrowing_params
    params.require(:borrowing).permit(:user_id, :book_id, :borrowed_at, :due_date, :returned_at)
  end

  def authorize_member
    render_error(:unauthorized, 'Not authorized') unless current_user&.member?
  end

  def authorize_admin
    render_error('Not authorized', :unauthorized) unless current_user&.admin?
  end

  def render_error(message, status)
    render json: { error: message }, status: status
  end
end
