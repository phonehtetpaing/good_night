# frozen_string_literal: true

# Serializes users into JSON format.
class UserSerializer
  include JSONAPI::Serializer

  attributes :name
  has_many :sleep_records
end
