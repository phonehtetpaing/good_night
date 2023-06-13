class UsersController < ApplicationController
  before_action :authenticate_user!

  def follow
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: { status: 'error', message: 'User to follow not found' }, status: :not_found
    elsif @current_user.follow(user)
      render json: { status: 'success', message: 'User followed' }, status: :ok
    else
      render json: { status: 'error', message: 'User is already followed' }, status: :unprocessable_entity
    end
  end
  
  
  def unfollow
    user = User.find_by(id: params[:id])
    if user.nil?
        render json: { status: 'error', message: 'User to unfollow not found' }, status: :not_found
    elsif @current_user.unfollow(user)
        render json: { status: 'success', message: 'User unfollowed' }, status: :ok
    else
      render json: { status: 'error', message: 'User is not followed' }, status: :unprocessable_entity
    end
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