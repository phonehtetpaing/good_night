# frozen_string_literal: true

class SleepRecord < ApplicationRecord
  validates :user_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true

  belongs_to :user
end
