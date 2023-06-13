class UsersController < ApplicationController
  include Authenticatable

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
  
end
