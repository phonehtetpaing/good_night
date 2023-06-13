# frozen_string_literal: true

# UserFollower represents a user following another user in the application
class UserFollower < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followed, class_name: 'User'
end
