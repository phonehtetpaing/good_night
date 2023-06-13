# Create users
user1 = User.create(name: 'Ichigo Kurosaki')
user2 = User.create(name: 'Sasuke Uchiha')
user3 = User.create(name: 'Naruto Uzumaki')
user4 = User.create(name: 'Goku')

# Create sleep records for user1
sleep_record1 = SleepRecord.create(start_time: Time.current - 8.hours, end_time: Time.current - 6.hours, user: user1)
sleep_record2 = SleepRecord.create(start_time: Time.current - 7.hours, end_time: Time.current - 2.hours, user: user1)
sleep_record5 = SleepRecord.create(start_time: Time.current - 6.hours, end_time: Time.current - 4.hours, user: user1)

# Create sleep records for user2
sleep_record3 = SleepRecord.create(start_time: Time.current - 6.hours, end_time: Time.current - 4.hours, user: user2)
sleep_record4 = SleepRecord.create(start_time: Time.current - 5.hours, end_time: Time.current - 3.hours, user: user2)

# Create sleep records for user3
sleep_record6 = SleepRecord.create(start_time: Time.current - 9.hours, end_time: Time.current - 7.hours, user: user3)
sleep_record7 = SleepRecord.create(start_time: Time.current - 6.hours, end_time: Time.current - 4.hours, user: user3)

# Create sleep records for user4
sleep_record8 = SleepRecord.create(start_time: Time.current - 10.hours, end_time: Time.current - 2.hours, user: user4)
sleep_record9 = SleepRecord.create(start_time: Time.current - 5.hours, end_time: Time.current - 4.hours, user: user4)

# User1 follows User2 and User3
user1.follow(user2)
user1.follow(user3)

# User2 follows User1 and User4
user2.follow(user1)
user2.follow(user4)

# User3 follows User1 and User4
user3.follow(user1)
user3.follow(user4)

# User4 follows User2 and User3
user4.follow(user2)
user4.follow(user3)