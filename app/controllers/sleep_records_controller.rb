# frozen_string_literal: true

# The SleepRecordsController handles requests related to sleep records.
# It provides actions for creating and retrieving sleep records in descending order.
class SleepRecordsController < ApplicationController
  include Authenticatable

  def index
    sleep_records = SleepRecord.order(created_at: :desc)
    render json: serialize_sleep_records(sleep_records), status: :ok
  end

  def create
    sleep_record = SleepRecord.new(sleep_record_params)
    sleep_record.user_id = @current_user.id
    if sleep_record.save
      render json: serialize_sleep_records(sleep_record), status: :created
    else
      render_unauthorized_error(422, sleep_record.errors)
    end
  end

  private

  def sleep_record_params
    params.require(:sleep_record).permit(:start_time, :end_time)
  end

  def serialize_sleep_records(records)
    return [] unless records

    SleepRecordSerializer.new(records).serializable_hash.to_json
  end

  def render_unauthorized_error(status, message)
    error_string = ErrorSerializer.serialize(status:, message:)
    render json: error_string, status:
  end
end
