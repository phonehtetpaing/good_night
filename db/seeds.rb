# Create users
user1 = User.create(name: 'Ichigo Kurosaki')
user2 = User.create(name: 'Sasuke Uchiha')

# Create sleep records
SleepRecord.create(start_time: Time.current - 8.hours, end_time: Time.current - 6.hours, user: user1)
SleepRecord.create(start_time: Time.current - 7.hours, end_time: Time.current - 5.hours, user: user1)
SleepRecord.create(start_time: Time.current - 6.hours, end_time: Time.current - 4.hours, user: user2)
SleepRecord.create(start_time: Time.current - 5.hours, end_time: Time.current - 3.hours, user: user2)