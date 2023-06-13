# frozen_string_literal: true

FactoryBot.define do
  factory :sleep_record do
    start_time { Time.current }
    end_time { Time.current + 8.hours }
    association :user
  end
end
