# frozen_string_literal: true

# UsersController handles user-related actions such as following/unfollowing other users
# and retrieving sleep records of followed users.
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

    return render json: { error: 'User not found' }, status: :not_found if user.nil?

    followed_users = user.following_users
    sleep_records = SleepRecord.where(user: followed_users)
                               .sort_by { |record| record.end_time - record.start_time }
                               .reverse
    render json: serialize_sleep_records(sleep_records), status: :ok
  end

  private

  def serialize_sleep_records(records)
    SleepRecordSerializer.new(records).serializable_hash.to_json
  end
end
