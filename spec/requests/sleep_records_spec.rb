require 'rails_helper'

RSpec.describe 'Sleep Records API', type: :request do
  describe 'POST /sleep_records/clock_in' do
    let(:user) { create(:user) }
    let(:jwt_token) { JWT.encode({ user_id: user.id }, 'secret_key', 'HS256') }
    context 'when the request is valid' do
      it 'creates a new sleep record' do
        sleep_record_params = { start_time: Time.current, end_time: Time.current + 8.hours }

        post '/sleep_records/clock_in', params: { sleep_record: sleep_record_params }, headers: { 'Authorization' => "Bearer #{jwt_token}" }
      
        expect(response).to have_http_status(:created)
        parsed_response = JSON.parse(response.body)
        expect(Time.parse(parsed_response['start_time']).strftime('%Y-%m-%dT%H:%M:%SZ')).to eq(sleep_record_params[:start_time].iso8601)
        expect(Time.parse(parsed_response['end_time']).strftime('%Y-%m-%dT%H:%M:%SZ')).to eq(sleep_record_params[:end_time].iso8601)
        expect(SleepRecord.count).to eq(1)
      end
    end

    context 'when the request is invalid' do
      it 'returns validation errors' do
        invalid_sleep_record_params = { start_time: nil }

        post '/sleep_records/clock_in', params: { sleep_record: invalid_sleep_record_params }, headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        parsed_response = JSON.parse(response.body)
        expect(parsed_response['errors']['start_time']).to include("can't be blank")
        expect(parsed_response['errors']['end_time']).to include("can't be blank")
        expect(SleepRecord.count).to eq(0)
      end
    end
  end

  describe 'GET /sleep_records' do
    let(:user) { create(:user) }
    let(:jwt_token) { JWT.encode({ user_id: user.id }, 'secret_key', 'HS256') }
    it 'returns all sleep records ordered by creation time' do
      sleep_record1 = create(:sleep_record, created_at: 1.hour.ago,)
      sleep_record2 = create(:sleep_record, created_at: 2.hours.ago)

      get '/sleep_records', headers: { 'Authorization' => "Bearer #{jwt_token}" }

      expect(response).to have_http_status(:ok)
      parsed_response = JSON.parse(response.body)
      expect(parsed_response.length).to eq(2)
      expect(parsed_response[0]['id']).to eq(sleep_record2.id)
      expect(parsed_response[1]['id']).to eq(sleep_record1.id)
    end
  end
end
