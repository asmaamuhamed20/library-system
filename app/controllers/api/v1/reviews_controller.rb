  class Api::V1::ReviewsController < ApplicationController
    before_action :set_review, only: [:show, :update, :destroy]
    before_action :authorize_admin, only: [:destroy]
    before_action :authorize_member, only: [:create]

    # Retrieves a list of all reviews.
    #
    # @return [Array<Review>] The list of reviews.
    # @example Request
    #   GET /api/v1/reviews
    # @example Response
    #   HTTP Status: 200 OK
    def index
      reviews = Review.all
      render json: reviews, status: :ok
    end

    # Retrieves a specific review by its ID.
    #
    # @param id [Integer] The ID of the review to retrieve.
    # @return [Review] The requested review.
    # @example Request
    #   GET /api/v1/reviews/{id}
    # @example Response
    #   HTTP Status: 200 OK
    def show
      render json: @review, status: :ok
    end

    # Creates a new review.
    #
    # @param review_params [Hash] The parameters for creating a new review.
    # @option review_params [Integer] :book_id The ID of the book being reviewed.
    # @option review_params [Integer] :rating The rating of the book (1-5).
    # @option review_params [String] :comment The comment for the review.
    # @return [Review] The created review.
    # @example Request
    #   POST /api/v1/reviews
    #   Request Body: { "review": { "book_id": 1, "rating": 5, "comment": "Excellent book!" } }
    # @example Response
    #   HTTP Status: 201 Created
    def create
      result = Review.create_with_params(review_params.merge(user_id: current_user.id))
      if result[:status] == :created
        render json: result[:review], status: :created
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    end

    # Updates an existing review.
    #
    # @param id [Integer] The ID of the review to update.
    # @param review_params [Hash] The parameters for updating the review.
    # @option review_params [Integer] :book_id The ID of the book being reviewed.
    # @option review_params [Integer] :rating The new rating of the book (1-5).
    # @option review_params [String] :comment The new comment for the review.
    # @return [Review] The updated review.
    # @example Request
    #   PATCH /api/v1/reviews/1
    #   Request Body: { "review": { "rating": 4, "comment": "Good book, but could be better." } }
    # @example Response
    #   HTTP Status: 200 OK
    def update
      result = @review.update_with_params(review_params)
      if result[:status] == :ok
        render json: result[:review], status: :ok
      else
        render json: result[:errors], status: :unprocessable_entity
      end
    end

    # Deletes a specific review by its ID.
    #
    # @param id [Integer] The ID of the review to delete.
    # @return [Head] No content.
    # @example Request
    #   DELETE /api/v1/reviews/1
    # @example Response
    #   HTTP Status: 204 No Content
    def destroy
      @review.destroy
      head :no_content
    end


    private

    # Sets the review instance variable based on the ID(review_id) provided in the params.
    #
    # @raise [ActiveRecord::RecordNotFound] If the review is not found.
    # @return [Review] The review with the given ID
    def set_review
      @review = Review.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Review not found' }, status: :not_found
    end
    
    # Permits the parameters for creating/updating a review.
    #
    # @return [ActionController::Parameters] The permitted parameters
    def review_params
      params.require(:review).permit( :book_id, :rating, :comment)
    end
    
    # Authorizes that the current user is an admin.
    #
    # @raise [StandardError] If the user is not authorized
    def authorize_admin
      render json: { error: 'Not authorized' }, status: :unauthorized unless current_user&.admin?
    end

    # Authorizes that the current user is a member.
    #
    # @raise [StandardError] If the user is not authorized.
    def authorize_member
      render json: { error: 'Not authorized' }, status: :unauthorized unless current_user&.member?
    end
  end
