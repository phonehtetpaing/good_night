class User < ApplicationRecord
  validates :name, presence: true

  has_many :sleep_records
end