# frozen_string_literal: true

# UsersController handles user-related actions such as following/unfollowing other users
# and retrieving sleep records of followed users.
class UsersController < ApplicationController
  include Authenticatable

  def follow
    user = User.find_by(id: params[:id])
    if user.nil?
      render_serialized_errors(404, 'User to follow not found')
    elsif @current_user.follow(user)
      render json: { data: { status: 'success', message: 'User followed' } }, status: :ok
    else
      render_serialized_errors(422, 'User is already followed')
    end
  end

  def unfollow
    user = User.find_by(id: params[:id])
    if user.nil?
      render_serialized_errors(404, 'User to unfollow not found')
    elsif @current_user.unfollow(user)
      render json: { data: { status: 'success', message: 'User unfollowed' } }, status: :ok
    else
      render_serialized_errors(422, 'User is not followed')
    end
  end

  def followed_sleep_records
    user = User.find_by(id: params[:id])

    return render_serialized_errors(404, 'User not found') if user.nil?

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

  def render_serialized_errors(status, message)
    error_string = ErrorSerializer.serialize(status:, message:)
    render json: error_string, status:
  end
end
