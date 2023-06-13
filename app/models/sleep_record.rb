# frozen_string_literal: true

# SleepRecord represents a sleep record in the application
class SleepRecord < ApplicationRecord
  validates :user_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  belongs_to :user
end
