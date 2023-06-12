class SleepRecordsController < ApplicationController
  before_action :authenticate_user!

  def index
    sleep_records = SleepRecord.order(created_at: :asc)
    render json: sleep_records
  end

  def create
    sleep_record = SleepRecord.new(sleep_record_params)
    sleep_record.user_id = @current_user.id
    if sleep_record.save
      render json: sleep_record, status: :created
    else
      render json: { errors: sleep_record.errors }, status: :unprocessable_entity
    end
  end

  private

  def sleep_record_params
    params.require(:sleep_record).permit(:start_time, :end_time)
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
