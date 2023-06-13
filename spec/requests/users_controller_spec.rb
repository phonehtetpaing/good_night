# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :request do
  describe 'POST /users/:id/follow' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:jwt_token) { JWT.encode({ user_id: user.id }, 'secret_key', 'HS256') }

    context 'when the request is valid' do
      it 'follows the user' do
        post "/users/#{other_user.id}/follow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['message']).to eq('User followed')
        expect(user.following?(other_user)).to be true
      end
    end

    context 'when the request is invalid' do
      it 'returns an error if the user is already followed' do
        user.follow(other_user)

        post "/users/#{other_user.id}/follow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['errors'][0]['detail']).to eq('User is already followed')
        expect(user.following?(other_user)).to be true
      end

      it 'returns an error if the user to follow does not exist' do
        post '/users/999/follow', headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors'][0]['detail']).to eq('User to follow not found')
      end
    end
  end

  describe 'DELETE /users/:id/unfollow' do
    let!(:user) { create(:user) }
    let!(:other_user) { create(:user) }
    let(:jwt_token) { JWT.encode({ user_id: user.id }, 'secret_key', 'HS256') }

    before { user.follow(other_user) }

    context 'when the request is valid' do
      it 'unfollows the user' do
        delete "/users/#{other_user.id}/unfollow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:ok)
        expect(response.parsed_body['data']['message']).to eq('User unfollowed')
        expect(user.following?(other_user)).to be false
      end
    end

    context 'when the request is invalid' do
      it 'returns an error if the user is not followed' do
        user.unfollow(other_user)

        delete "/users/#{other_user.id}/unfollow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['errors'][0]['detail']).to eq('User is not followed')
        expect(user.following?(other_user)).to be false
      end

      it 'returns an error if the user to unfollow does not exist' do
        delete '/users/999/unfollow', headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors'][0]['detail']).to eq('User to unfollow not found')
      end
    end
  end

  describe 'GET /users/:id/followed_sleep_records' do
    let!(:user) { create(:user) }
    let(:jwt_token) { JWT.encode({ user_id: user.id }, 'secret_key', 'HS256') }
    let!(:followed_user1) { create(:user) }
    let!(:followed_user2) { create(:user) }
    let!(:sleep_record1) do
      create(:sleep_record, user: followed_user1, start_time: 1.week.ago, end_time: 1.week.ago + 8.hours)
    end
    let!(:sleep_record2) do
      create(:sleep_record, user: followed_user2, start_time: 1.week.ago, end_time: 1.week.ago + 6.hours)
    end

    before { user.follow(followed_user1) }
    before { user.follow(followed_user2) }

    context 'when the user has no followed users' do
      before { user.unfollow(followed_user1) }
      before { user.unfollow(followed_user2) }

      it 'returns an empty array' do
        get "/users/#{user.id}/followed_sleep_records", headers: { 'Authorization' => "Bearer #{jwt_token}" }
      
        expect(response).to have_http_status(:ok)
        expect(JSON.parse(response.body)).to eq({ "data" => [] })
      end
    end

    context 'when the user does not exist' do
      it 'returns an error' do
        get '/users/999/followed_sleep_records', headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['errors'][0]['detail']).to eq('User not found')
      end
    end

    context 'when the request is valid' do
      it 'returns the sleep records of followed users from the previous week sorted by start_time' do
        get "/users/#{user.id}/followed_sleep_records", headers: { 'Authorization' => "Bearer #{jwt_token}" }
    
        expect(response).to have_http_status(:ok)
    
        parsed_response = JSON.parse(response.body)
        sleep_records = parsed_response['data']
    
        expect(sleep_records.length).to eq(2)
    
        sleep_record_ids = sleep_records.map { |record| record['id'] }
        expect(sleep_record_ids).to include(sleep_record1.id.to_s, sleep_record2.id.to_s)
    
        start_times = sleep_records.map { |record| record['attributes']['start_time'] }
        expected_start_times = [sleep_record1.start_time.iso8601, sleep_record2.start_time.iso8601]
        expect(start_times.map { |t| Time.parse(t).strftime('%Y-%m-%dT%H:%M:%SZ') }).to eq(expected_start_times)
      end
    end    
  end
end
