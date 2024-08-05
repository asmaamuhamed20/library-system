class Api::V1::BorrowingsController < ApplicationController
  def create
    @borrowing = Borrowing.new(borrowing_params)
    if @borrowing.save
      render json: @borrowing, status: :created
    else
      render json: @borrowing.errors, status: :unprocessable_entity
    end
  end

  def update
    if @borrowing.update(borrowing_params)
      render json: @borrowing, status: :ok
    else
      render json: @borrowing.errors, status: :unprocessable_entity
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
    params.require(:borrowing).permit(:user_id, :book_id, :borrowed_on, :due_date, :returned_on)
  end

  def authorize_member
    render_error(:unauthorized, 'Not authorized') unless current_user&.member?
  end

  def authorize_admin
    render_error(:unauthorized, 'Not authorized') unless current_user&.admin?
  end
end
