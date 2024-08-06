# spec/support/auth_helper.rb
module AuthHelper
  def authenticate_user(user)
    token = JsonWebToken.encode(user_id: user.id)
    { 'Authorization' => "Bearer #{token}" }
  end
end
