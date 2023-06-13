# frozen_string_literal: true

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

  def followed_sleep_records
    user = User.find_by(id: params[:id])
    if user.nil?
      render json: { error: 'User not found' }, status: :not_found
    else
      followed_users = user.following_users
      sleep_records = SleepRecord.where(user: followed_users)
                                 .sort_by { |record| record.end_time - record.start_time }
                                 .reverse
      render json: sleep_records, status: :ok
    end
  end
end
