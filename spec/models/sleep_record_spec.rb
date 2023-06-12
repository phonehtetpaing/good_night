require 'rails_helper'

RSpec.describe SleepRecord, type: :model do
  it { should validate_presence_of(:user_id) }
  it { should validate_presence_of(:start_time) }
  it { should validate_presence_of(:end_time) }

  it { should belong_to(:user) }
end
