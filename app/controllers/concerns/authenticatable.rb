# frozen_string_literal: true

# The Authenticatable module provides authentication-related methods and helpers
# for user authentication in controllers.
module Authenticatable
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
  end

  def authenticate_user!
    # I am mocking JWT here but we can use other authentication gems like Devise
    token = request.headers['Authorization']&.split&.last
    decoded_token = JWT.decode(token, 'secret_key', true, algorithm: 'HS256')
    @current_user = User.find_by(id: decoded_token.first['user_id'])
    render_unauthorized_error unless @current_user
  rescue JWT::DecodeError
    render_unauthorized_error
  end

  def render_unauthorized_error
    error_string = ErrorSerializer.serialize(status: 401, message: 'Invalid credentials')
    render json: error_string, status:
  end
end
