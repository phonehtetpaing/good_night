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
        expect(response.parsed_body['status']).to eq('success')
        expect(response.parsed_body['message']).to eq('User followed')
        expect(user.following?(other_user)).to be true
      end
    end

    context 'when the request is invalid' do
      it 'returns an error if the user is already followed' do
        user.follow(other_user)

        post "/users/#{other_user.id}/follow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['status']).to eq('error')
        expect(response.parsed_body['message']).to eq('User is already followed')
        expect(user.following?(other_user)).to be true
      end

      it 'returns an error if the user to follow does not exist' do
        post '/users/999/follow', headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['status']).to eq('error')
        expect(response.parsed_body['message']).to eq('User to follow not found')
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
        expect(response.parsed_body['status']).to eq('success')
        expect(response.parsed_body['message']).to eq('User unfollowed')
        expect(user.following?(other_user)).to be false
      end
    end

    context 'when the request is invalid' do
      it 'returns an error if the user is not followed' do
        user.unfollow(other_user)

        delete "/users/#{other_user.id}/unfollow", headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:unprocessable_entity)
        expect(response.parsed_body['status']).to eq('error')
        expect(response.parsed_body['message']).to eq('User is not followed')
        expect(user.following?(other_user)).to be false
      end

      it 'returns an error if the user to unfollow does not exist' do
        delete '/users/999/unfollow', headers: { 'Authorization' => "Bearer #{jwt_token}" }

        expect(response).to have_http_status(:not_found)
        expect(response.parsed_body['status']).to eq('error')
        expect(response.parsed_body['message']).to eq('User to unfollow not found')
      end
    end
  end
end
