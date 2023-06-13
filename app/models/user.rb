# frozen_string_literal: true

# User represents a user in the application
class User < ApplicationRecord
  validates :name, presence: true

  has_many :followings, class_name: 'UserFollower', foreign_key: 'follower_id', dependent: :destroy
  has_many :followers, through: :followings, source: :followed
  has_many :followeds, class_name: 'UserFollower', foreign_key: 'followed_id', dependent: :destroy
  has_many :following_users, through: :followeds, source: :follower

  has_many :sleep_records

  def follow(user)
    following_users << user unless following?(user)
  end

  def unfollow(user)
    following_users.delete(user) if following?(user)
  end

  def following?(user)
    following_users.exists?(user.id)
  end
end
