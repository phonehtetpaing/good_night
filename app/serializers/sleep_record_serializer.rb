# frozen_string_literal: true

# Serializes sleep records into JSON format.
class SleepRecordSerializer
  include JSONAPI::Serializer

  attributes :start_time, :end_time
  belongs_to :user
end
