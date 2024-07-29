class ApplicationController < ActionController::API
  before_action :authenticate_user!

  
  def authenticate_user!
    token = request.headers['Authorization']&.split(' ')&.last
    decoded = JsonWebToken.decode(token)
    @current_user = User.find_by(id: decoded[:user_id]) if decoded
    render_unauthorized unless @current_user
  rescue
    render_unauthorized
  end

  def current_user
    @current_user
  end

  private

  def render_unauthorized
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
