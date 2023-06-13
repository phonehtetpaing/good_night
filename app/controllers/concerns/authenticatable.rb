# frozen_string_literal: true

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
    render json: { error: 'Unauthorized' }, status: :unauthorized unless @current_user
  rescue JWT::DecodeError
    render json: { error: 'Unauthorized' }, status: :unauthorized
  end
end
